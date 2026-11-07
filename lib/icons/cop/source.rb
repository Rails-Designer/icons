# frozen_string_literal: true

module Icons
  module Cop
    class Source
      class << self
        def matches?(node, pattern)
          return false unless node.method_name == pattern.method

          if pattern.receiver
            node.receiver.respond_to?(:const_name) && constant_name(node.receiver) == pattern.receiver
          else
            node.receiver.nil?
          end
        end

        private

        def constant_name(node)
          node.const_name.to_s.delete_prefix("::")
        end
      end

      def initialize(node, pattern, config: Config.new)
        @node = node
        @pattern = pattern
        @config = config
      end

      def references
        library_name = library
        return [] if library_name == :dynamic || library_name.nil?

        variant = variant_for(library_name)

        name_nodes.filter_map do |name_node|
          name = literal(name_node)
          next if name.nil?

          Reference.new(name: name.to_s, node: name_node, library: library_name, variant: variant)
        end
      end

      private

      def library
        return @pattern.fixed_library if @pattern.fixed_library
        return @pattern.default_library || @config.default_library if @pattern.library_arg.nil?

        value_node = keyword_value(@pattern.library_arg)
        return @pattern.default_library || @config.default_library if value_node.nil?

        value = literal(value_node)
        return :dynamic if value.nil?

        value.to_sym
      end

      def variant_for(library)
        return default_variant(library) if @pattern.variant_arg.nil?

        value_node = keyword_value(@pattern.variant_arg)
        return default_variant(library) if value_node.nil?

        value = literal(value_node)
        return :dynamic if value.nil?

        variant_name(value)
      end

      def name_nodes
        if @pattern.icons_arg
          value = keyword_value(@pattern.icons_arg)
          return [] if value.nil?
          return value.values if value.array_type?

          [value]
        else
          value = if @pattern.name_arg == :positional
            positional_argument
          else
            keyword_value(@pattern.name_arg)
          end

          value ? [value] : []
        end
      end

      def positional_argument
        first = @node.arguments.first
        first unless first&.hash_type?
      end

      def keyword_value(key)
        hash = @node.arguments.last
        return unless hash&.hash_type?

        pair = hash.pairs.find do |candidate|
          key_node = candidate.key
          (key_node.sym_type? || key_node.str_type?) && key_node.value.to_sym == key.to_sym
        end

        pair&.value
      end

      def literal(node)
        return if node.nil?
        return node.value if node.str_type? || node.sym_type?

        nil
      end

      def variant_name(value)
        return if value.nil?

        string = value.to_s
        return if string.empty? || string == "."

        string
      end

      def default_variant(library)
        library_default = @config.libraries.dig(library.to_sym, :default_variant)

        variant_name(library_default || @config.default_variant)
      end
    end
  end
end
