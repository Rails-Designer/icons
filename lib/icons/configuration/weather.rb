# frozen_string_literal: true

require "icons/configuration/options"

module Icons
  class Configuration
    module Weather
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
          # Override Weather defaults
          # config.libraries.weather.default_variant = "" # Set a default variant for Wweather
          # config.libraries.weather.exclude_variants = []

          # config.libraries.weather.default.css = "size-6"
          # config.libraries.weather.default.data = {}
        RB
      end

      def source
        {
          url: "https://github.com/erikflowers/weather-icons.git",
          variants: {
            ".": "svg" # Weather has no variants, store in the top directory
          }
        }
      end

      def transformations
        {
          filenames: {
            delete_prefix: ["wi-"]
          }
        }
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
