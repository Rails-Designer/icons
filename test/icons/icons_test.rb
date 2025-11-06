# frozen_string_literal: true

require "test_helper"

class IconsTest < Minitest::Test
  def test_configure_yields_configuration
    Icons.configure do |config|
      assert_instance_of Icons::Configuration, config
    end
  end

  def test_config_returns_configuration
    assert_instance_of Icons::Configuration, Icons.config
  end

  def test_libraries_returns_hash
    assert_instance_of Hash, Icons.libraries
  end

  def test_configuration_is_singleton
    Icons.configure do |config|
      config.default_library = :test
    end

    assert_equal :test, Icons.config.default_library
  end
end
