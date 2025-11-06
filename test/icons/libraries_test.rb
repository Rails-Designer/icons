# frozen_string_literal: true

require "test_helper"

class Icons::LibrariesTest < Minitest::Test
  def test_libraries_returns_hash
    assert_instance_of Hash, Icons.libraries
  end

  def test_all_expected_libraries_present
    expected = [:boxicons, :feather, :flags, :heroicons, :linear, :lucide, :phosphor, :radix, :sidekickicons, :tabler, :weather]

    expected.each do |library|
      assert Icons.libraries.key?(library), "Expected #{library} to be present"
    end
  end

  def test_library_has_config
    Icons.libraries.each do |name, library|
      assert library.respond_to?(:config), "#{name} should respond to :config"
    end
  end

  def test_library_has_source
    Icons.libraries.each do |name, library|
      assert library.respond_to?(:source), "#{name} should respond to :source"
    end
  end

  def test_library_source_has_url_and_variants
    Icons.libraries.each do |name, library|
      source = library.source

      assert source[:url], "#{name} should have a URL"
      assert source[:variants], "#{name} should have variants"
    end
  end
end
