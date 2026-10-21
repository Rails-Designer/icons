# frozen_string_literal: true

module Icons
  class Prune
    class Scanner
      module SpriteRecording
        private

        def record_sprite_hash(hash)
          return unless hash.is_a?(Prism::HashNode) || hash.is_a?(Prism::KeywordHashNode)

          hash.elements.grep(Prism::AssocNode).each do |library_pair|
            library = literal(library_pair.key)&.to_sym

            unless library
              @all_libraries_dynamic = true
              next
            end

            record_sprite_variants(library, library_pair.value)
          end
        end

        def record_sprite_variants(library, variants)
          unless variants.is_a?(Prism::HashNode) || variants.is_a?(Prism::KeywordHashNode)
            @dynamic_libraries << library
            return
          end

          variants.elements.grep(Prism::AssocNode).each do |variant_pair|
            variant = sprite_variant(variant_pair.key)
            names = variant_pair.value

            unless names.is_a?(Prism::ArrayNode)
              @dynamic_libraries << library
              next
            end

            names.elements.each do |name_node|
              name = literal(name_node)

              if name
                @references << Reference.new(library: library, variant: variant, name: name)
              else
                @dynamic_libraries << library
              end
            end
          end
        end

        def sprite_variant(node)
          value = literal(node)

          value ? normalize_variant(value) : :any
        end
      end
    end
  end
end
