# frozen_string_literal: true

require "pathname"

module Icons
  class Prune
    class Scanner
      class TextFile
        include VariantResolver

        def initialize(path:, root:, config:, text_patterns:)
          @path = path
          @root = root
          @config = config
          @text_patterns = text_patterns
        end

        def scan(collector)
          references = Set.new
          text = File.read(@path)

          @text_patterns.each do |pattern|
            text.scan(pattern.regexp) do |captures|
              add_reference(references, pattern, Array(captures))
            end
          end

          collector.add(
            FileScan.new(
              references: references,
              dynamic_libraries: Set.new,
              file_literals: Set.new,
              declaration_literals: Set.new,
              all_libraries_dynamic: false
            )
          )
        rescue => error
          collector.add_parse_failure(
            ParseFailure.new(path: relative_path, message: "#{error.class}: #{error.message}")
          )
        end

        private

        attr_reader :config

        def add_reference(references, pattern, captures)
          library = text_pattern_value(pattern.library, captures)&.to_s&.to_sym
          name = text_pattern_value(pattern.name, captures)&.to_s
          return if library.nil? || name.nil? || name.empty?

          variant = if pattern.variant.nil?
            default_variant_for(library)
          else
            normalize_variant(text_pattern_value(pattern.variant, captures))
          end

          references << Reference.new(library: library, variant: variant, name: name)
        end

        def text_pattern_value(value, captures)
          case value
          when Integer then captures[value - 1]
          when Symbol, String then value
          end
        end

        def relative_path
          Pathname.new(@path).relative_path_from(@root).to_s
        rescue ArgumentError
          @path.to_s
        end
      end
    end
  end
end
