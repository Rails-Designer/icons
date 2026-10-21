# frozen_string_literal: true

module Icons
  class Prune
    class Scanner
      module DeclarationCollecting
        private

        def collect_declaration(value_node)
          value_node = unwrap(value_node)

          case value_node
          when Prism::SymbolNode, Prism::StringNode
            value = value_node.unescaped
            @declaration_literals << value if icon_name?(value)
          when Prism::ArrayNode
            value_node.elements.each { |element| collect_declaration(element) }
          when Prism::HashNode
            value_node.elements.grep(Prism::AssocNode).each do |element|
              collect_declaration(element.value)
            end
          end
        end

        def unwrap(value_node)
          loop do
            case value_node
            when Prism::CallNode
              break unless freeze_call?(value_node) && value_node.receiver

              value_node = value_node.receiver
            when Prism::ParenthesesNode
              value_node = value_node.body
            when Prism::StatementsNode
              break unless value_node.body.size == 1

              value_node = value_node.body.first
            else
              break
            end
          end

          value_node
        end

        def freeze_call?(node)
          node.name == :freeze && node.receiver && (node.arguments.nil? || node.arguments.arguments.empty?)
        end
      end
    end
  end
end
