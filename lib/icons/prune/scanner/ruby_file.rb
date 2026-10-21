# frozen_string_literal: true

require "pathname"
require "prism"

module Icons
  class Prune
    class Scanner
      class RubyFile
        def initialize(path:, root:, config:, call_patterns:)
          @path = path
          @root = root
          @config = config
          @call_patterns = call_patterns
        end

        def scan(collector)
          result = Prism.parse_file(@path)

          unless result.errors.empty?
            messages = result.errors.map(&:message).join("; ")

            collector.add_parse_failure(ParseFailure.new(path: relative_path, message: messages))

            return
          end

          visitor = Visitor.new(config: @config, call_patterns: @call_patterns)
          visitor.visit(result.value)

          collector.add(
            FileScan.new(
              references: visitor.references,
              dynamic_libraries: visitor.dynamic_libraries,
              file_literals: visitor.file_literals,
              declaration_literals: visitor.declaration_literals,
              all_libraries_dynamic: visitor.all_libraries_dynamic
            )
          )
        rescue => error
          collector.add_parse_failure(
            ParseFailure.new(path: relative_path, message: "#{error.class}: #{error.message}")
          )
        end

        private

        def relative_path
          Pathname.new(@path).relative_path_from(@root).to_s
        rescue ArgumentError
          @path.to_s
        end
      end
    end
  end
end
