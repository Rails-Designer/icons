# frozen_string_literal: true

require "test_helper"

class Icons::CustomLibraryTest < Minitest::Test
  def setup
    super

    Icons.configure do |config|
      config.custom_library :simple
    end
  end

  def test_registers_custom_library
    assert Icons.libraries.key?(:simple)
  end

  def test_resolves_icon_via_app_path
    icon = Icons::Icon.new(name: "apple", library: :simple, arguments: {})

    assert_match(/xmlns/, icon.svg)
  end

  def test_custom_library_with_source_is_syncable
    Icons.configure do |config|
      config.custom_library :my_git_lib, source: {
        url: "https://github.com/user/icons.git",
        variants: { default: "." }
      }
    end

    assert Icons.libraries.key?(:my_git_lib)

    sync = Icons::Sync.new(:my_git_lib)
    assert_instance_of Icons::Sync, sync
  end
end
