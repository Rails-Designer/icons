# frozen_string_literal: true

module Icons
  class Icon
    class Attributes
      def initialize(default_attributes: {}, arguments: {})
        @merged_attributes = default_attributes.merge(arguments)
      end

      def attach(to:)
        @merged_attributes.each do |key, value|
          if key == :class
            class_attribute(key, value, to)
          elsif value.is_a?(Hash)
            hash_attributes(key, value, to)
          else
            string_attributes(key, value, to)
          end
        end
      end

      private

      def class_attribute(_, value, to)
        to[:class] = token_list(value)
      end

      def token_list(value)
        case value
        when Array
          # Flatten and process each element
          value.flatten.map { |v|
            if v.is_a?(Hash)
              v.select { |_, val| val }.keys.map(&:to_s).join(" ")
            else
              v.to_s
            end
          }.compact.reject(&:empty?).join(" ")
        when Hash
          # Handle both string and symbol keys, filter truthy values
          value.select { |_, v| v }.keys.map(&:to_s).join(" ")
        else
          value.to_s
        end
      end

      def hash_attributes(key, value, to)
        value.each do |nested_key, nested_value|
          nested_attribute_name = format_attribute_name("#{key}-#{nested_key}")

          to[nested_attribute_name] = nested_value
        end
      end

      def string_attributes(key, value, to)
        normalized_key = format_attribute_name(key.to_s)

        to[normalized_key] = value
      end

      def format_attribute_name(name)
        name.tr("_", "-")
      end
    end
  end
end
