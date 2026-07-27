# frozen_string_literal: true

require "test_helper"

class Icons::SyncTest < Minitest::Test
  def test_clone_repository_uses_shallow_partial_sparse_clone
    sync = Icons::Sync.new("tabler")
    commands = stub_system_on(sync) { |cmd| true }

    capture_io { sync.send(:clone_repository) }

    assert_equal [
      "git clone --depth 1 --filter=blob:none --sparse 'https://github.com/tabler/tabler-icons.git' '#{temp_dir}'",
      "git -C '#{temp_dir}' sparse-checkout set 'icons/filled' 'icons/outline'"
    ], commands
  end

  def test_clone_repository_falls_back_to_full_clone_when_optimized_clone_fails
    sync = Icons::Sync.new("tabler")
    commands = stub_system_on(sync) { |cmd| !cmd.include?("--filter=blob:none") }

    capture_io { sync.send(:clone_repository) }

    assert commands.first.include?("--filter=blob:none"),
      "Expected first command to be the sparse clone attempt"
    assert_equal "git clone 'https://github.com/tabler/tabler-icons.git' '#{temp_dir}'", commands.last
  end

  def test_clone_repository_raises_when_full_clone_also_fails
    sync = Icons::Sync.new("tabler")
    stub_system_on(sync) { |cmd| false }

    assert_raises(RuntimeError) { capture_io { sync.send(:clone_repository) } }
  end

  def test_sparse_checkout_paths_returns_only_wanted_variants
    sync = Icons::Sync.new("tabler", variants: [:filled])
    paths = sync.send(:sparse_checkout_paths)

    assert_equal "'icons/filled'", paths
  end

  def test_sparse_checkout_paths_returns_all_when_variants_is_nil
    sync = Icons::Sync.new("tabler")
    paths = sync.send(:sparse_checkout_paths)

    assert_equal "'icons/filled' 'icons/outline'", paths
  end

  private

  def temp_dir
    Icons.configuration.base_path.join("tmp/icons/tabler").to_s
  end

  def stub_system_on(sync, &block)
    [].tap do |commands|
      sync.define_singleton_method(:system) { |cmd| commands << cmd; block.call(cmd) }
    end
  end
end
