# frozen_string_literal: true

module Icons
  class Prune
    class Runner
      def initialize(root:, icons_root:, dry_run:, config:, call_patterns:, text_patterns:)
        @root = root
        @icons_root = icons_root
        @dry_run = dry_run
        @config = config
        @call_patterns = call_patterns
        @text_patterns = text_patterns
      end

      def call
        scan = Scanner.new(
          root: @root,
          config: @config,
          call_patterns: @call_patterns,
          text_patterns: @text_patterns
        ).scan

        raise_parse_failures(scan.parse_failures) unless @dry_run || scan.parse_failures.empty?

        plan = Plan.new(
          references: scan.references,
          dynamic_icon_names: scan.dynamic_icon_names,
          icons_root: @icons_root,
          config: @config
        )

        raise_missing_references(plan.missing_references) unless @dry_run || plan.missing_references.empty?

        raise_no_references unless @dry_run || plan.references_found?

        plan.delete_icons unless @dry_run

        raise_missing_references(plan.missing_references) unless @dry_run || plan.missing_references.empty?

        Report.new(plan: plan, dry_run: @dry_run, parse_failures: scan.parse_failures)
      end

      private

      def raise_parse_failures(failures)
        paths = failures.map(&:path)

        raise PruneError.new("Could not parse: #{paths.join(", ")}", kind: :parse)
      end

      def raise_missing_references(references)
        names = references.map do |reference|
          [reference.library, reference.variant, reference.name].compact.join("/")
        end

        raise PruneError.new("Referenced icons are missing: #{names.join(", ")}", kind: :verification)
      end

      def raise_no_references
        raise PruneError.new("No icon references were found. Refusing to prune.", kind: :no_references)
      end
    end
  end
end
