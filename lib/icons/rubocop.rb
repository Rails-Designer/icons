# frozen_string_literal: true

require "yaml"
require "rubocop"
require "icons"
require "icons/cop"
require "rubocop/cop/icons/icon_name"

module RuboCop
  module Icons
    module Inject
      def self.defaults!
        path = File.expand_path("../../config/default.yml", __dir__)
        hash = YAML.load_file(path)

        RuboCop::ConfigLoader.default_configuration =
          RuboCop::ConfigLoader.default_configuration.merge(hash)
      end
    end
  end
end

RuboCop::Icons::Inject.defaults!
