# frozen_string_literal: true

module Icons
  class Prune
    class Plan
      class Classifier
        def initialize(icon_files:, keep_list:)
          @icon_files = icon_files
          @keep_list = keep_list
        end

        def classify
          kept_paths = []
          deleted_paths = []
          library_stats = []
          skipped_libraries = []
          skipped_library_names = Set.new
          bytes_deleted = 0

          @icon_files.each_group do |library, variant, paths|
            if (reason = @keep_list.skip_reason_for(library))
              record_skipped(skipped_libraries, skipped_library_names, library, reason)
              next
            end

            unless @keep_list.library_has_evidence?(library)
              record_skipped(skipped_libraries, skipped_library_names, library, :no_evidence)
              next
            end

            names = @keep_list.names_to_keep(library, variant)
            kept, deleted = paths.partition { |path| keep_path?(path, names) }
            group_bytes_deleted = deleted.sum { |path| File.size(path) }

            kept_paths.concat(kept)
            deleted_paths.concat(deleted)
            bytes_deleted += group_bytes_deleted

            library_stats << LibraryStat.new(
              library: library,
              variant: variant,
              kept_icon_count: kept.size,
              deleted_icon_count: deleted.size,
              bytes_deleted: group_bytes_deleted
            )
          end

          Result.new(
            kept_paths: kept_paths,
            deleted_paths: deleted_paths,
            library_stats: library_stats,
            skipped_libraries: skipped_libraries,
            bytes_deleted: bytes_deleted
          )
        end

        private

        def keep_path?(path, names)
          name = File.basename(path, ".svg")

          names.any? { |pattern| pattern == name || File.fnmatch?(pattern, name) }
        end

        def record_skipped(libraries, library_names, library, reason)
          return if library_names.include?(library)

          library_names << library
          libraries << SkippedLibrary.new(library: library, reason: reason)
        end
      end
    end
  end
end
