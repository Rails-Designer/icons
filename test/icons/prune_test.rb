# frozen_string_literal: true

require "test_helper"
require "support/prune_helper"

class Icons::PruneTest < Minitest::Test
  include PruneHelper

  def test_icons_prune_returns_a_report
    write_icon(:lucide, :outline, "check")
    write_source "app/models/home.rb", 'Icons::Icon.new(name: "check", library: :lucide)'

    report = prune

    assert_equal "Icons::Prune::Report", report.class.name
    assert_match(/dry-run/, report.to_s)
  end

  def test_the_prune_class_can_be_used_directly
    write_icon(:lucide, :outline, "check")
    write_source "app/models/home.rb", 'Icons::Icon.new(name: "check", library: :lucide)'

    report = Icons::Prune.new(dry_run: true).call

    assert_equal 1, report.kept_icon_count
  end

  def test_internal_classes_are_private_constants
    require "icons/prune/scanner"

    assert_raises(NameError) { Icons::Prune::Reference }
    assert_raises(NameError) { Icons::Prune::CallPattern }
    assert_raises(NameError) { Icons::Prune::TextPattern }
    assert_raises(NameError) { Icons::Prune::Scanner }
    assert_raises(NameError) { Icons::Prune::Plan }

    assert_equal "Class", Icons::Prune::Report.class.name
  end

  def test_registry_restores_default_patterns
    Icons::Prune.register_call_pattern(method: :legacy_icon, name: :positional, library: :lucide)
    Icons::Prune.reset_patterns!

    write_icon(:lucide, :outline, "check")
    write_icon(:lucide, :outline, "legacy")
    write_source "app/models/home.rb", 'legacy_icon("legacy")'
    write_source "app/models/other.rb", 'Icons::Icon.new(name: "check", library: :lucide)'

    report = prune

    assert_equal ["legacy"], deleted_names(report)
  end

  def test_configuration_defaults_are_empty
    assert_equal [], Icons.config.keep_icons
    assert_equal [], Icons.config.skip_libraries
    assert_equal [], Icons.config.prune_source_globs
  end
end
