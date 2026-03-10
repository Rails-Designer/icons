# frozen_string_literal: true

require "icons/configuration/options"

module Icons
  class Configuration
    module Hugeicons
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
          # Override Hugeicons defaults
          # config.libraries.hugeicons.default_variant = "" # Hugeicons has no variants, this is provided for backwards compatibility
          # config.libraries.hugeicons.exclude_variants = [] # Hugeicons has no variants, this is provided for backwards compatibility

          # config.libraries.hugeicons.default.css = "size-6"
          # config.libraries.hugeicons.default.stroke_width = "1.5"
          # config.libraries.hugeicons.default.data = {}
        RB
      end

      def source
        {
          url: "https://github.com/hugeicons/hugeicons-static.git",
          variants: {
            ".": "icons" # Hugeicons free icons are in a single directory
          }
        }
      end

      private

      def default_options
        Options.new.tap do |options|
          options.stroke_width = "1.5"
          options.css = "size-6"
          options.data = {}
        end
      end
    end
  end
end
