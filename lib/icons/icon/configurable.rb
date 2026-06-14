# frozen_string_literal: true

module Icons
  class Icon
    module Configurable
      private

      def set_variant
        value = @config.libraries.dig(@library, :default_variant) || @config.default_variant

        value.to_s.empty? ? nil : value
      end

      def error_message
        attributes = [
          @library,
          @variant,
          @name
        ].compact

        "Icon not found: `#{attributes.join(" / ")}`"
      end

      def attach_attributes(to:)
        Icons::Icon::Attributes
          .new(default_attributes: default_attributes, arguments: @arguments)
          .attach(to: to)
      end

      def default_attributes
        {
          "stroke-width": default(:stroke_width),
          data: default(:data),
          class: default(:css)
        }.compact
      end

      def default(key)
        library_attributes.dig(:default, key)
      end

      def library_attributes
        keys = [@library, @variant].compact

        @config.libraries.dig(*keys) || {}
      end
    end
  end
end
