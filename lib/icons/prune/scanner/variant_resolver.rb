# frozen_string_literal: true

module Icons
  class Prune
    class Scanner
      module VariantResolver
        private

        def default_variant_for(library)
          value = config.libraries.dig(library.to_sym, :default_variant) || config.default_variant

          normalize_variant(value)
        end

        def normalize_variant(variant)
          return if variant.nil?

          string = variant.to_s
          return if string.empty? || string == "."

          string
        end
      end
    end
  end
end
