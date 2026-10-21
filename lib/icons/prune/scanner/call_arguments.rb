# frozen_string_literal: true

module Icons
  class Prune
    class Scanner
      module CallArguments
        private

        def resolve_library(node, pattern)
          return pattern.fixed_library if pattern.fixed_library
          return pattern.default_library || config.default_library if pattern.library_arg.nil?

          value_node = keyword_value(node, pattern.library_arg)
          return pattern.default_library || config.default_library if value_node.nil?

          value = literal(value_node)

          unless value
            @all_libraries_dynamic = true
            return
          end

          value.to_sym
        end

        def resolve_name_nodes(node, pattern)
          if pattern.icons_arg
            value_node = keyword_value(node, pattern.icons_arg)
            return [] if value_node.nil?
            return value_node.elements if value_node.is_a?(Prism::ArrayNode)

            return [value_node]
          end

          value_node = if pattern.name_arg == :positional
            first_argument(node)
          else
            keyword_value(node, pattern.name_arg)
          end

          value_node ? [value_node] : []
        end

        def resolve_variant(node, pattern, library)
          return default_variant_for(library) if pattern.variant_arg.nil?

          value_node = keyword_value(node, pattern.variant_arg)
          return default_variant_for(library) if value_node.nil?

          value = literal(value_node)
          return :any unless value

          normalize_variant(value)
        end
      end
    end
  end
end
