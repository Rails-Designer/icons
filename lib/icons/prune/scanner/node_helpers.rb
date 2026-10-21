# frozen_string_literal: true

module Icons
  class Prune
    class Scanner
      module NodeHelpers
        ICON_NAME = /\A[a-zA-Z0-9][a-zA-Z0-9_-]*\z/

        private

        def literal(node)
          return unless node.is_a?(Prism::SymbolNode) || node.is_a?(Prism::StringNode)

          node.unescaped
        end

        def first_argument(node)
          node.arguments&.arguments&.first
        end

        def keyword_value(node, key)
          return if key.nil?

          pair = keyword_pairs(node).find do |element|
            element.key.is_a?(Prism::SymbolNode) && element.key.unescaped.to_sym == key.to_sym
          end

          pair&.value
        end

        def keyword_pairs(node)
          arguments = node.arguments&.arguments || []
          hash = arguments.find do |argument|
            argument.is_a?(Prism::KeywordHashNode) || argument.is_a?(Prism::HashNode)
          end

          hash ? hash.elements.grep(Prism::AssocNode) : []
        end

        def constant_path(node)
          case node
          when Prism::ConstantReadNode
            node.name.to_s
          when Prism::ConstantPathNode
            parent = node.parent && constant_path(node.parent)
            [parent, node.name.to_s].compact.join("::")
          end
        end

        def collect_literal(raw)
          return unless icon_name?(raw)

          @file_literals << raw
        end

        def icon_name?(value)
          value.is_a?(String) && value.match?(ICON_NAME)
        end
      end
    end
  end
end
