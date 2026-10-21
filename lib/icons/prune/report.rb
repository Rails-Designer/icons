# frozen_string_literal: true

module Icons
  class Prune
    class Report
      DELETED_NAMES_PREVIEW_LIMIT = 20

      attr_reader :skipped_libraries, :parse_failures, :dry_run

      def initialize(plan:, dry_run:, parse_failures:)
        @plan = plan
        @dry_run = dry_run
        @parse_failures = parse_failures
        @library_stats = plan.library_stats
        @skipped_libraries = plan.skipped_libraries
      end

      def dry_run?
        dry_run
      end

      def kept_icon_count
        @plan.kept_icon_count
      end

      def deleted_icon_count
        @plan.deleted_icon_count
      end

      def deleted_icon_names
        @plan.deleted_icon_names
      end

      def bytes_freed
        @plan.bytes_freed
      end

      def to_s
        [].tap do |lines|
          lines << headline
          lines.concat(library_stat_lines)
          lines << deleted_icon_names_preview if deleted_icon_names.any?
          lines << skipped_libraries_line if skipped_libraries.any?
          lines << parse_failures_line if parse_failures.any?
          lines << "  Re-run with dry_run: false to delete." if dry_run?
        end.join("\n")
      end

      private

      def headline
        prefix = dry_run? ? "[dry-run] " : ""
        action = dry_run? ? "Would prune" : "Pruned"

        "#{prefix}#{action} #{deleted_icon_count} icons, kept #{kept_icon_count}, freed #{human_bytes(bytes_freed)}"
      end

      def library_stat_lines
        @library_stats.sort_by { |stat| [stat.library.to_s, stat.variant.to_s] }.map do |stat|
          "  #{stat.library}/#{stat.variant || "."}: #{stat.deleted_icon_count} deleted, #{stat.kept_icon_count} kept"
        end
      end

      def deleted_icon_names_preview
        preview_names = deleted_icon_names.first(DELETED_NAMES_PREVIEW_LIMIT)

        "  e.g. #{preview_names.join(", ")}"
      end

      def skipped_libraries_line
        libraries = skipped_libraries.map { |skipped| "#{skipped.library} (#{skipped.reason})" }

        "  Skipped: #{libraries.join(", ")}"
      end

      def parse_failures_line
        paths = parse_failures.map(&:path)

        "  Could not parse: #{paths.join(", ")}"
      end

      def human_bytes(bytes)
        units = %w[B KB MB GB]
        size = bytes.to_f
        unit = units.shift

        while size >= 1024 && units.any?
          size /= 1024
          unit = units.shift
        end

        (unit == "B") ? "#{bytes} B" : format("%.2f %s", size, unit)
      end
    end
  end
end
