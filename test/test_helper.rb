# frozen_string_literal: true

# TODO: check all below

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "icons"

require "minitest/autorun"
require "nokogiri"
require "pathname"

module IconsTestHelper
  def setup
    @original_config = Icons.configuration

    Icons.configuration = Icons::Configuration.new
    Icons.configure do |config|
      config.base_path = Pathname.new(File.expand_path("fixtures", __dir__))
      config.default_library = :heroicons
    end
  end

  def teardown
    Icons.configuration = @original_config
  end
end

class Minitest::Test
  include IconsTestHelper
end
