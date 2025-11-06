# frozen_string_literal: true

require "icons/configuration/options"

module Icons
  class Configuration
    module Radix
      extend self

      def config
        Options.new.tap do |options|
          options.default_variant = nil
          options.exclude_variants = []

          options.default = default_options
        end
      end

      def initializer_config
        <<~RB.indent(2)
          # Override Radix defaults
          # config.libraries.radix.default_variant = "" # Radix has no variants, this is provided for backwards compatibility
          # config.libraries.radix.exclude_variants = [] # Radix has no variants, this is provided for backwards compatibility
          # config.libraries.radix.default.css = "size-6"
          # config.libraries.radix.default.stroke_width = "2"
          # config.libraries.radix.default.data = {}
        RB
      end

      def source
        {
          url: "https://github.com/radix-ui/icons.git",
          variants: {
            ".": "packages/radix-icons/icons" # Radix has no variants, store in the top directory
          }
        }
      end

      private

      def default_options
        Options.new.tap do |options|
          options.css = "size-4"
          options.data = {}
        end
      end
    end
  end
end
