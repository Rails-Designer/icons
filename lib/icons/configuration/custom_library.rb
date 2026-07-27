# frozen_string_literal: true

module Icons
  class Configuration
    class CustomLibrary
      attr_reader :source

      def initialize(source: nil)
        @source = source
      end

      def config
        Options.new.tap do |options|
          options.default_variant = nil
          options.exclude_variants = []
        end
      end

      def initializer_config
        ""
      end
    end
  end
end
