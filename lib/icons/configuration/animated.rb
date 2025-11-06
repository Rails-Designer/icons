# frozen_string_literal: true

require "icons/configuration/options"

module Icons
  class Configuration
    module Animated
      extend self

      def config
        Options.new.tap do |options|
          options.default = default_options
        end
      end

      private

      def default_options
        Options.new.tap do |options|
          options.css = "size-6"
          options.data = {}
        end
      end
    end
  end
end
