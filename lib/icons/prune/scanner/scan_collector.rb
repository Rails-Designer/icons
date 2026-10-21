# frozen_string_literal: true

module Icons
  class Prune
    class Scanner
      class ScanCollector
        def initialize
          @references = Set.new
          @dynamic_icon_names = Hash.new { |hash, key| hash[key] = Set.new }
          @parse_failures = []
          @declaration_literals = Set.new
          @file_literals = Hash.new { |hash, key| hash[key] = Set.new }
          @all_file_literals = Set.new
          @dynamic_libraries = Set.new
          @all_libraries_dynamic = false
        end

        def add(file_scan)
          @references.merge(file_scan.references)
          @declaration_literals.merge(file_scan.declaration_literals)
          @dynamic_libraries.merge(file_scan.dynamic_libraries)
          @all_libraries_dynamic ||= file_scan.all_libraries_dynamic
          @all_file_literals.merge(file_scan.file_literals)

          file_scan.dynamic_libraries.each do |library|
            @file_literals[library].merge(file_scan.file_literals)
          end
        end

        def add_parse_failure(failure)
          @parse_failures << failure
        end

        def to_scan
          expand_dynamic_icon_names

          Scan.new(
            references: @references,
            dynamic_icon_names: @dynamic_icon_names,
            parse_failures: @parse_failures
          )
        end

        private

        def expand_dynamic_icon_names
          libraries.each do |library|
            @dynamic_icon_names[library].merge(literals_for(library))
            @dynamic_icon_names[library].merge(@declaration_literals)
          end
        end

        def libraries
          @all_libraries_dynamic ? Icons.libraries.keys : @dynamic_libraries
        end

        def literals_for(library)
          @all_libraries_dynamic ? @all_file_literals : @file_literals[library]
        end
      end
    end
  end
end
