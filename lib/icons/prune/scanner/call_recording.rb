# frozen_string_literal: true

module Icons
  class Prune
    class Scanner
      module CallRecording
        private

        def record_call(node)
          record_sprite_hash(first_argument(node)) if node.name == :sprite= && first_argument(node)

          call_patterns.each do |pattern|
            next unless matches?(node, pattern)

            record_pattern(node, pattern)
            break
          end
        end

        def matches?(node, pattern)
          return false unless node.name == pattern.method

          if pattern.receiver
            constant_path(node.receiver) == pattern.receiver
          else
            node.receiver.nil?
          end
        end

        def record_pattern(node, pattern)
          library = resolve_library(node, pattern)
          return if library.nil?

          name_nodes = resolve_name_nodes(node, pattern)
          variant = resolve_variant(node, pattern, library)

          if name_nodes.empty?
            @dynamic_libraries << library
            return
          end

          name_nodes.each do |name_node|
            name = literal(name_node)

            if name.nil?
              @dynamic_libraries << library
            else
              @references << Reference.new(library: library, variant: variant, name: name)
            end
          end
        end
      end
    end
  end
end
