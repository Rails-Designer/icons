# frozen_string_literal: true

module Icons
  class Prune
  end
end

require "icons/prune/reference"
require "icons/prune/call_pattern"
require "icons/prune/text_pattern"
require "icons/prune/registry"
require "icons/prune/scan_values"
require "icons/prune/scanner"
require "icons/prune/plan"
require "icons/prune/report"
require "icons/prune/runner"

module Icons
  class Prune
    class << self
      def call_patterns
        Registry.call_patterns
      end

      def text_patterns
        Registry.text_patterns
      end

      # @param receiver [String, nil] Constant path the call is made on, nil for bare helpers
      # @param method [Symbol] Method name
      # @param name [Symbol, :positional] Keyword or positional argument holding the name
      # @param icons [Symbol, nil] Keyword holding an array of names (sprites)
      # @param library [Symbol, nil] Keyword holding the library
      # @param variant [Symbol, nil] Keyword holding the variant
      # @param fixed_library [Symbol, nil] Library for helpers that do not take one
      # @param default_library [Symbol, nil] Library when the call omits one
      #
      def register_call_pattern(**options)
        Registry.register_call_pattern(**options)
      end

      # @param regexp [Regexp]
      # @param library [Integer, Symbol] Capture index or fixed library
      # @param name [Integer, Symbol] Capture index or fixed name
      # @param variant [Integer, Symbol, nil] Capture index, fixed variant, or nil for the library default
      #
      def register_text_pattern(regexp, **options)
        Registry.register_text_pattern(regexp, **options)
      end

      def reset_patterns!
        Registry.reset_patterns!
      end
    end

    # @param root [Pathname, String] Application root scanned for references
    # @param icons_root [Pathname, String, nil] Synced icons directory
    # @param dry_run [Boolean] When true, nothing is deleted
    # @param config [Icons::Configuration]
    #
    def initialize(root: Icons.config.base_path, icons_root: nil, dry_run: true, config: Icons.configuration)
      @root = root
      @icons_root = icons_root || config.base_path.join(config.icons_path)
      @dry_run = dry_run
      @config = config
    end

    # @return [Report]
    # @raise [Icons::PruneError] when the scan or verification fails in commit mode
    #
    def call
      Runner.new(
        root: @root,
        icons_root: @icons_root,
        dry_run: @dry_run,
        config: @config,
        call_patterns: self.class.call_patterns,
        text_patterns: self.class.text_patterns
      ).call
    end

    private_constant :Reference, :CallPattern, :TextPattern, :Registry, :ParseFailure, :FileScan, :Scan,
      :Scanner, :Plan, :Runner
  end
end
