# frozen_string_literal: true

module Icons
  class Prune
    class Scanner
      class SourceFiles
        RUBY_GLOBS = ["app/**/*.rb", "lib/**/*.rb", "config/**/*.rb"].freeze
        TEMPLATE_GLOBS = ["app/**/*.erb", "app/**/*.haml", "app/**/*.slim"].freeze

        def initialize(root:, config:)
          @root = root
          @config = config
        end

        def ruby_files
          glob(RUBY_GLOBS)
        end

        def template_files
          glob(TEMPLATE_GLOBS + Array(@config.prune_source_globs)) - ruby_files
        end

        private

        def glob(patterns)
          patterns.flat_map { |pattern| Dir.glob(@root.join(pattern).to_s) }.uniq
        end
      end
    end
  end
end
