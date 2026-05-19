# frozen_string_literal: true

require "nokogiri"

module Icons
  class Sync
    class Transformations
      def self.transform(filename, rules = {})
        basename = File.basename(filename, File.extname(filename))

        transformed = rules.fetch(:filenames, {}).reduce(basename) do |fn, (type, value)|
          FILENAME_TRANSFORMERS.fetch(type).call(fn, value)
        end

        [transformed, File.extname(filename)].join
      end

      def self.transform_svg(file_path, rules = [])
        return unless rules.any?

        svg_document = Nokogiri::HTML::DocumentFragment.parse(File.read(file_path))

        rules.each do |rule|
          SVG_TRANSFORMERS.fetch(rule[:action]).call(
            svg_document,
            rule[:element],
            rule[:attribute],
            rule[:value]
          )
        end

        File.write(file_path, svg_document.to_html)
      end

      private

      FILENAME_TRANSFORMERS = {
        delete_prefix: ->(filename, prefixes) {
          Array(prefixes).reduce(filename) { |fn, prefix| fn.delete_prefix(prefix) }
        },

        delete_suffix: ->(filename, suffixes) {
          Array(suffixes).reduce(filename) { |fn, suffix| fn.delete_suffix(suffix) }
        }
      }

      SVG_TRANSFORMERS = {
        set_attribute: ->(document, element_selector, attribute_name, attribute_value) {
          document.css(element_selector).each do |element|
            element[attribute_name] = attribute_value
          end
        }
      }
    end
  end
end
