# frozen_string_literal: true

module Icons
  class Sync
    class Transformations
      def self.transform(filename, rules = {})
        basename = File.basename(filename, File.extname(filename))

        transformed = rules.reduce(basename) do |fn, (type, value)|
          TRANSFORMERS.fetch(type).call(fn, value)
        end

        [transformed, File.extname(filename)].join
      end

      private

      TRANSFORMERS = {
        delete_prefix: ->(filename, prefixes) {
          Array(prefixes).reduce(filename) { |fn, prefix| fn.delete_prefix(prefix) }
        },

        delete_suffix: ->(filename, suffixes) {
          Array(suffixes).reduce(filename) { |fn, suffix| fn.delete_suffix(suffix) }
        }
      }
    end
  end
end
