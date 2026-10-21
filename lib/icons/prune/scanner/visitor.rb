# frozen_string_literal: true

module Icons
  class Prune
    class Scanner
      class Visitor < Prism::Visitor
        include NodeHelpers
        include VariantResolver
        include CallArguments
        include CallRecording
        include DeclarationCollecting
        include SpriteRecording

        attr_reader :references, :dynamic_libraries, :file_literals,
          :declaration_literals, :all_libraries_dynamic

        def initialize(config:, call_patterns:)
          @config = config
          @call_patterns = call_patterns
          @references = Set.new
          @dynamic_libraries = Set.new
          @file_literals = Set.new
          @declaration_literals = Set.new
          @all_libraries_dynamic = false

          super()
        end

        def visit_call_node(node)
          record_call(node)

          super
        end

        def visit_string_node(node)
          collect_literal(node.unescaped)

          super
        end

        def visit_symbol_node(node)
          collect_literal(node.unescaped)

          super
        end

        def visit_constant_write_node(node)
          collect_declaration(node.value) if node.name.to_s.match?(/ICON/i)

          super
        end

        def visit_assoc_node(node)
          key = node.key

          if (key.is_a?(Prism::SymbolNode) || key.is_a?(Prism::StringNode)) && key.unescaped.match?(/icon/i)
            collect_declaration(node.value)
          end

          super
        end

        private

        attr_reader :config, :call_patterns
      end
    end
  end
end
