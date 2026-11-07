# frozen_string_literal: true

require "test_helper"
require "fileutils"
require "tmpdir"
require "rubocop"
require "icons/rubocop"

class IconNameCopTest < Minitest::Test
  def setup
    super

    @root = Pathname.new(Dir.mktmpdir)
    Icons.config.base_path = @root
    Icons.config.icons_path = "icons"
    Icons.config.default_library = :lucide
    Icons.config.default_variant = nil

    @cop_config = RuboCop::Config.new(
      "Icons/IconName" => {"Enabled" => true}
    )
  end

  def teardown
    Icons::Cop.reset_call_patterns!
    FileUtils.remove_entry(@root) if @root&.exist?

    super
  end

  def test_existing_icon_has_no_offenses
    write_icon(:lucide, :outline, "check")

    assert_empty offenses('Icons::Icon.new(name: "check", library: :lucide, arguments: {})')
  end

  def test_missing_icon_is_reported
    write_icon(:lucide, :outline, "check")

    result = offenses('Icons::Icon.new(name: "check-circle", library: :lucide, arguments: {})')

    assert_equal 1, result.size
    assert_match(/Icon `check-circle` not found in lucide\/outline/, result.first.message)
  end

  def test_suggests_a_close_name
    write_icon(:lucide, :outline, "circle-check")

    result = offenses('Icons::Icon.new(name: "circle-chek", library: :lucide, arguments: {})')

    assert_match(/Did you mean `circle-check`\?/, result.first.message)
  end

  def test_symbol_name_is_supported
    write_icon(:lucide, :outline, "check")

    assert_empty offenses('Icons::Icon.new(name: :check, library: :lucide, arguments: {})')
  end

  def test_sprite_array_reports_each_missing_icon
    write_icon(:lucide, :outline, "check")

    result = offenses('Icons::Sprite.new(icons: ["check", "missing"], library: :lucide)')

    assert_equal 1, result.size
    assert_match(/missing/, result.first.message)
  end

  def test_dynamic_name_is_ignored
    assert_empty offenses("Icons::Icon.new(name: icon_name, library: :lucide, arguments: {})")
  end

  def test_dynamic_library_is_ignored
    assert_empty offenses('Icons::Icon.new(name: "check", library: library_name, arguments: {})')
  end

  def test_explicit_variant_is_checked
    write_icon(:lucide, :outline, "check")

    result = offenses('Icons::Icon.new(name: "check", library: :lucide, variant: :solid, arguments: {})')

    assert_match(/not found in lucide\/solid/, result.first.message)
    assert_match(/exists in lucide\/outline/, result.first.message)
  end

  def test_library_default_variant_is_used
    write_icon(:lucide, :outline, "check")

    assert_empty offenses('Icons::Icon.new(name: "check", library: :lucide, arguments: {})')
  end

  def test_configured_default_library_is_used
    write_icon(:lucide, :outline, "check")

    assert_empty offenses('Icons::Icon.new(name: "check", arguments: {})')
  end

  def test_registered_call_pattern_is_checked
    Icons::Cop.register_call_pattern(method: :icon, name: :positional, library: :library, variant: :variant)
    write_icon(:lucide, :outline, "check")

    result = offenses('icon "missing", library: :lucide')

    assert_equal 1, result.size
  end

  def test_unsynced_library_is_skipped
    assert_empty offenses('Icons::Icon.new(name: "check", library: :heroicons, arguments: {})')
  end

  def test_dynamic_variant_checks_all_variants
    write_icon(:lucide, :outline, "check")

    assert_empty offenses('Icons::Icon.new(name: "check", library: :lucide, variant: variant_name, arguments: {})')
  end

  def test_dynamic_variant_reports_when_missing_everywhere
    write_icon(:lucide, :outline, "check")

    result = offenses('Icons::Icon.new(name: "missing", library: :lucide, variant: variant_name, arguments: {})')

    assert_match(/not found in any lucide variant/, result.first.message)
  end

  def test_leading_colons_are_supported
    write_icon(:lucide, :outline, "check")

    assert_empty offenses('::Icons::Icon.new(name: "check", library: :lucide, arguments: {})')
  end

  private

  def write_icon(library, variant, name)
    directory = @root.join("icons", library.to_s)
    directory = directory.join(variant.to_s) unless variant.nil?
    FileUtils.mkdir_p(directory)
    File.write(directory.join("#{name}.svg"), '<svg xmlns="http://www.w3.org/2000/svg"></svg>')
  end

  def offenses(source, config: @cop_config)
    processed_source = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
    cop = RuboCop::Cop::Icons::IconName.new(config)
    commissioner = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)

    report = commissioner.investigate(processed_source)

    report.cop_reports.flat_map(&:offenses)
  end
end
