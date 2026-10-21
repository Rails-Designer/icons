# frozen_string_literal: true

require "icons/prune/plan/icon_files"
require "icons/prune/plan/keep_list"
require "icons/prune/plan/reference_verifier"
require "icons/prune/plan/deletion_manifest"
require "icons/prune/plan/library_stat"
require "icons/prune/plan/skipped_library"
require "icons/prune/plan/classifier"
require "icons/prune/plan/result"

module Icons
  class Prune
    class Plan
      attr_reader :library_stats, :skipped_libraries

      def initialize(references:, dynamic_icon_names:, icons_root:, config:)
        @references = references
        @dynamic_icon_names = dynamic_icon_names
        @config = config
        @icon_files = IconFiles.new(icons_root: icons_root)
        @keep_list = KeepList.new(
          references: references,
          dynamic_icon_names: dynamic_icon_names,
          config: config
        )

        result = Classifier.new(icon_files: @icon_files, keep_list: @keep_list).classify

        @kept_paths = result.kept_paths
        @deleted_paths = result.deleted_paths
        @library_stats = result.library_stats
        @skipped_libraries = result.skipped_libraries
        @bytes_deleted = result.bytes_deleted
      end

      def kept_icon_count
        @kept_paths.size
      end

      def deleted_icon_count
        @deleted_paths.size
      end

      def deleted_icon_names
        @deleted_paths.map { |path| File.basename(path, ".svg") }.uniq
      end

      def bytes_freed
        @bytes_deleted
      end

      def missing_references
        verifier.missing_references
      end

      def references_found?
        @references.any? || @dynamic_icon_names.any? { |_library, names| names.any? }
      end

      def delete_icons
        return if @deleted_paths.empty?

        @deleted_paths.each { |path| File.delete(path) }

        DeletionManifest.new(config: @config).write(@deleted_paths)
      end

      private

      def verifier
        @verifier ||= ReferenceVerifier.new(
          references: @references,
          icon_files: @icon_files,
          config: @config
        )
      end
    end
  end
end
