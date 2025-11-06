# frozen_string_literal: true

require "test_helper"

class Icons::ConfigurationTest < Minitest::Test
  def setup
    Icons.configuration = nil
  end

  def test_default_library_configuration
    config = Icons::Configuration.new

    assert_nil config.default_library
  end

  def test_default_icons_path
    config = Icons::Configuration.new

    assert_equal "app/assets/svg/icons", config.icons_path
  end

  def test_base_path_defaults_to_current_directory
    config = Icons::Configuration.new

    assert_instance_of Pathname, config.base_path
  end

  def test_base_path_can_be_set
    config = Icons::Configuration.new
    config.base_path = "/custom/path"

    assert_equal Pathname.new("/custom/path"), config.base_path
  end

  def test_libraries_are_loaded
    config = Icons::Configuration.new

    refute_empty config.libraries
    assert config.libraries[:heroicons]
  end

  def test_configure_block
    Icons.configure do |config|
      config.default_library = :lucide
      config.icons_path = "custom/icons"
    end

    assert_equal :lucide, Icons.config.default_library
    assert_equal "custom/icons", Icons.config.icons_path
  end
end
