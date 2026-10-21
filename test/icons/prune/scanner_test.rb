# frozen_string_literal: true

require "test_helper"
require "support/prune_helper"

class Icons::Prune::ScannerTest < Minitest::Test
  include PruneHelper

  def test_literal_icon_call_keeps_the_icon_at_the_library_default_variant
    write_icon(:lucide, :outline, "check")
    write_icon(:lucide, :outline, "unused")
    write_source "app/models/home.rb", 'Icons::Icon.new(name: "check", library: :lucide)'

    report = prune

    assert_equal ["unused"], deleted_names(report)
    assert_equal 1, report.kept_icon_count
  end

  def test_literal_variant_keeps_only_that_variant
    write_icon(:lucide, :outline, "check")
    write_icon(:lucide, :filled, "check")
    write_source "app/models/home.rb", 'Icons::Icon.new(name: "check", library: :lucide, variant: :filled)'

    report = prune(dry_run: false)

    assert_equal ["check"], deleted_names(report)
    assert icon_path(:lucide, :filled, "check").exist?
    refute icon_path(:lucide, :outline, "check").exist?
  end

  def test_sprite_call_keeps_every_listed_icon
    write_icon(:lucide, :outline, "check")
    write_icon(:lucide, :outline, "search")
    write_icon(:lucide, :outline, "unused")
    write_source "app/models/sprite.rb", 'Icons::Sprite.new(icons: %w[check search], library: :lucide, variant: :outline)'

    report = prune

    assert_equal ["unused"], deleted_names(report)
  end

  def test_sprite_configuration_keeps_its_icons
    write_icon(:lucide, :outline, "check")
    write_icon(:lucide, :outline, "unused")
    write_source "config/initializers/icons.rb", <<~RUBY
      Icons.configure do |config|
        config.sprite = { lucide: { outline: ["check"] } }
      end
    RUBY

    report = prune

    assert_equal ["unused"], deleted_names(report)
  end

  def test_icon_constant_declaration_resolves_a_dynamic_name_from_another_file
    write_icon(:lucide, :outline, "message")
    write_icon(:lucide, :outline, "unused")
    write_source "app/models/channel.rb", 'CHANNEL_ICONS = { sms: :message }.freeze'
    write_source "app/models/renderer.rb", "Icons::Icon.new(name: channel_icon, library: :lucide)"

    report = prune

    assert_equal ["unused"], deleted_names(report)
  end

  def test_icon_hash_key_declaration_resolves_a_dynamic_name
    write_icon(:lucide, :outline, "gear")
    write_icon(:lucide, :outline, "unused")
    write_source "app/models/menu.rb", "MENU = { icon: :gear }"
    write_source "app/models/renderer.rb", "Icons::Icon.new(name: MENU[:icon], library: :lucide)"

    report = prune

    assert_equal ["unused"], deleted_names(report)
  end

  def test_dynamic_name_keeps_file_literals_for_its_library
    write_icon(:lucide, :outline, "check")
    write_icon(:lucide, :outline, "unused")
    write_source "app/models/renderer.rb", <<~RUBY
      ICONS = %w[check]
      Icons::Icon.new(name: ICONS.sample, library: :lucide)
    RUBY

    report = prune

    assert_equal ["unused"], deleted_names(report)
  end

  def test_dynamic_variant_keeps_the_icon_in_every_variant
    write_icon(:lucide, :outline, "check")
    write_icon(:lucide, :filled, "check")
    write_icon(:lucide, :outline, "unused")
    write_source "app/models/renderer.rb", 'Icons::Icon.new(name: "check", library: :lucide, variant: current_variant)'

    report = prune

    assert_equal ["unused"], deleted_names(report)
  end

  def test_dynamic_library_keeps_file_literals_for_every_library
    write_icon(:lucide, :outline, "check")
    write_icon(:heroicons, :outline, "check")
    write_icon(:heroicons, :outline, "unused")
    write_source "app/models/renderer.rb", 'Icons::Icon.new(name: "check", library: current_library)'

    report = prune

    assert_equal ["unused"], deleted_names(report)
  end

  def test_registered_text_pattern_keeps_a_template_reference
    Icons::Prune.register_text_pattern(/icon\s+"([a-z0-9_-]+)",\s+library:\s+:([a-z0-9_-]+)/, name: 1, library: 2)

    write_icon(:lucide, :outline, "check")
    write_icon(:lucide, :outline, "unused")
    write_source "app/views/home.html.erb", '<%= icon "check", library: :lucide %>'

    report = prune

    assert_equal ["unused"], deleted_names(report)
  end

  def test_default_variant_comes_from_the_library_configuration
    Icons.config.libraries.lucide.default_variant = :filled

    write_icon(:lucide, :outline, "check")
    write_icon(:lucide, :filled, "check")
    write_source "app/models/home.rb", 'Icons::Icon.new(name: "check", library: :lucide)'

    report = prune(dry_run: false)

    assert_equal ["check"], deleted_names(report)
    assert icon_path(:lucide, :filled, "check").exist?
    refute icon_path(:lucide, :outline, "check").exist?
  end

  def test_names_are_kept_verbatim_and_not_dasherized
    write_icon(:lucide, :outline, "circle_check")
    write_icon(:lucide, :outline, "circle-check")
    write_source "app/models/home.rb", 'Icons::Icon.new(name: "circle_check", library: :lucide)'

    report = prune(dry_run: false)

    assert_equal ["circle-check"], deleted_names(report)
    assert icon_path(:lucide, :outline, "circle_check").exist?
  end

  def test_parse_failures_are_reported_in_a_dry_run
    write_icon(:lucide, :outline, "check")
    write_source "app/broken.rb", "def broken("

    report = prune

    assert_equal 1, report.parse_failures.size
    assert_match(/app\/broken\.rb/, report.parse_failures.first.path)
  end

  def test_parse_failures_abort_a_committed_prune
    write_icon(:lucide, :outline, "check")
    write_source "app/broken.rb", "def broken("

    error = assert_raises(Icons::PruneError) { prune(dry_run: false) }

    assert_equal :parse, error.kind
    assert icon_path(:lucide, :outline, "check").exist?
  end

  def test_extra_prune_source_globs_are_scanned
    Icons.config.prune_source_globs = ["config/icons.yml"]

    write_icon(:lucide, :outline, "check")
    write_source "config/icons.yml", "menu: check"
    Icons::Prune.register_text_pattern(/menu:\s+([a-z0-9_-]+)/, name: 1, library: :lucide)

    report = prune

    assert_equal 1, report.kept_icon_count
  end
end
