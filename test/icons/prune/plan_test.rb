# frozen_string_literal: true

require "test_helper"
require "support/prune_helper"

class Icons::Prune::PlanTest < Minitest::Test
  include PruneHelper

  def test_flat_keep_icons_applies_to_every_library
    write_icon(:lucide, :outline, "menu")
    write_icon(:lucide, :outline, "unused")
    write_icon(:heroicons, :outline, "menu")
    write_icon(:heroicons, :outline, "unused")
    Icons.config.keep_icons = ["menu"]
    write_source "app/models/home.rb", 'Icons::Icon.new(name: "unused", library: :lucide)'
    write_source "app/models/other.rb", 'Icons::Icon.new(name: "unused", library: :heroicons)'

    report = prune

    assert_equal [], deleted_names(report)
  end

  def test_per_library_keep_icons_only_applies_to_that_library
    write_icon(:lucide, :outline, "menu")
    write_icon(:lucide, :outline, "unused")
    write_icon(:heroicons, :outline, "menu")
    write_icon(:heroicons, :outline, "unused")
    Icons.config.keep_icons = {lucide: ["menu"]}
    write_source "app/models/home.rb", 'Icons::Icon.new(name: "unused", library: :lucide)'
    write_source "app/models/other.rb", 'Icons::Icon.new(name: "unused", library: :heroicons)'

    report = prune(dry_run: false)

    assert_equal ["menu"], deleted_names(report)
    assert icon_path(:lucide, :outline, "menu").exist?
    refute icon_path(:heroicons, :outline, "menu").exist?
  end

  def test_keep_icons_accepts_globs
    write_icon(:lucide, :outline, "circle-check")
    write_icon(:lucide, :outline, "unused")
    Icons.config.keep_icons = ["circle-*"]
    write_source "app/models/home.rb", 'Icons::Icon.new(name: "unused", library: :lucide)'

    report = prune

    assert_equal [], deleted_names(report)
  end

  def test_skip_libraries_leaves_the_library_untouched
    write_icon(:lucide, :outline, "check")
    write_icon(:phosphor, :regular, "lock")
    Icons.config.skip_libraries = [:phosphor]
    write_source "app/models/home.rb", 'Icons::Icon.new(name: "check", library: :lucide)'

    report = prune

    assert icon_path(:phosphor, :regular, "lock").exist?
    assert_includes report.skipped_libraries.map(&:library), :phosphor
  end

  def test_a_library_without_evidence_is_skipped
    write_icon(:lucide, :outline, "check")
    write_icon(:tabler, :outline, "alarm")
    write_source "app/models/home.rb", 'Icons::Icon.new(name: "check", library: :lucide)'

    report = prune

    assert icon_path(:tabler, :outline, "alarm").exist?
    assert_includes report.skipped_libraries.map(&:library), :tabler
  end

  def test_a_dry_run_deletes_nothing
    write_icon(:lucide, :outline, "check")
    write_icon(:lucide, :outline, "unused")
    write_source "app/models/home.rb", 'Icons::Icon.new(name: "check", library: :lucide)'

    report = prune

    assert report.dry_run
    assert_equal 1, report.deleted_icon_count
    assert icon_path(:lucide, :outline, "unused").exist?
  end

  def test_a_committed_prune_deletes_and_writes_a_manifest
    write_icon(:lucide, :outline, "check")
    write_icon(:lucide, :outline, "unused")
    write_source "app/models/home.rb", 'Icons::Icon.new(name: "check", library: :lucide)'

    report = prune(dry_run: false)

    refute report.dry_run
    refute icon_path(:lucide, :outline, "unused").exist?
    assert icon_path(:lucide, :outline, "check").exist?

    manifest = @prune_root.join("tmp/icons-prune.json")
    assert manifest.exist?

    deleted = JSON.parse(manifest.read)
    assert_equal 1, deleted.size
    assert_match(%r{icons/lucide/outline/unused\.svg\z}, deleted.first)
  end

  def test_a_missing_reference_aborts_before_deleting_anything
    write_icon(:lucide, :outline, "unused")
    write_source "app/models/home.rb", 'Icons::Icon.new(name: "missing", library: :lucide)'

    error = assert_raises(Icons::PruneError) { prune(dry_run: false) }

    assert_equal :verification, error.kind
    assert icon_path(:lucide, :outline, "unused").exist?
  end

  def test_no_references_aborts_a_committed_prune
    write_icon(:lucide, :outline, "check")

    error = assert_raises(Icons::PruneError) { prune(dry_run: false) }

    assert_equal :no_references, error.kind
    assert icon_path(:lucide, :outline, "check").exist?
  end

  def test_non_svg_files_are_never_deleted
    write_icon(:lucide, :outline, "check")
    write_icon(:lucide, :outline, "unused")
    write_source "icons/lucide/outline/notes.txt", "keep me"
    write_source "app/models/home.rb", 'Icons::Icon.new(name: "check", library: :lucide)'

    prune(dry_run: false)

    assert @prune_root.join("icons/lucide/outline/notes.txt").exist?
  end

  def test_the_bundled_animated_library_is_skipped
    write_icon(:animated, nil, "faded-spinner")
    write_source "app/models/home.rb", 'Icons::Icon.new(name: "check", library: :lucide)'
    write_icon(:lucide, :outline, "check")

    prune(dry_run: false)

    assert icon_path(:animated, nil, "faded-spinner").exist?
  end

  def test_custom_path_libraries_are_skipped
    brand = Module.new do
      def self.config = Icons::Configuration::Options.new
      def self.custom_path = "brand"
      def self.source = nil
    end
    Icons.register_library(:brand, brand)

    write_icon(:brand, nil, "logo")
    write_icon(:lucide, :outline, "check")
    write_source "app/models/home.rb", 'Icons::Icon.new(name: "logo", library: :brand)'

    report = prune(dry_run: false)

    assert icon_path(:brand, nil, "logo").exist?
    assert_includes report.skipped_libraries.map(&:library), :brand
  end

  def test_a_dynamic_variant_keeps_the_icon_in_all_synced_variants
    write_icon(:lucide, :outline, "check")
    write_icon(:lucide, :filled, "check")
    write_source "app/models/home.rb", 'Icons::Icon.new(name: "check", library: :lucide, variant: current)'

    report = prune(dry_run: false)

    assert_equal 0, report.deleted_icon_count
    assert icon_path(:lucide, :outline, "check").exist?
    assert icon_path(:lucide, :filled, "check").exist?
  end
end
