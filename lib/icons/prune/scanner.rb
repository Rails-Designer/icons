# frozen_string_literal: true

require "pathname"
require "prism"

require "icons/prune/scan_values"
require "icons/prune/scanner/source_files"
require "icons/prune/scanner/scan_collector"
require "icons/prune/scanner/node_helpers"
require "icons/prune/scanner/variant_resolver"
require "icons/prune/scanner/call_arguments"
require "icons/prune/scanner/call_recording"
require "icons/prune/scanner/declaration_collecting"
require "icons/prune/scanner/sprite_recording"
require "icons/prune/scanner/visitor"
require "icons/prune/scanner/ruby_file"
require "icons/prune/scanner/text_file"

module Icons
  class Prune
    class Scanner
      def initialize(root:, config:, call_patterns:, text_patterns:)
        @root = Pathname.new(root.to_s)
        @config = config
        @call_patterns = call_patterns
        @text_patterns = text_patterns
      end

      def scan
        collector = ScanCollector.new

        source_files.ruby_files.each do |path|
          RubyFile.new(path: path, root: root, config: config, call_patterns: call_patterns).scan(collector)
        end

        source_files.template_files.each do |path|
          TextFile.new(path: path, root: root, config: config, text_patterns: text_patterns).scan(collector)
        end

        collector.to_scan
      end

      private

      attr_reader :root, :config, :call_patterns, :text_patterns

      def source_files
        @source_files ||= SourceFiles.new(root: root, config: config)
      end
    end
  end
end
