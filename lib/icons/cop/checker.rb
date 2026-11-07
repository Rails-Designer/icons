# frozen_string_literal: true

require "did_you_mean"

module Icons
  module Cop
    class Checker
      MSG_MISSING = "Icon `%<name>s` not found in %<location>s.%<suggestion>s"
      MSG_OTHER_VARIANT = "Icon `%<name>s` not found in %<location>s. It exists in %<variants>s."
      MSG_ANY_VARIANT = "Icon `%<name>s` not found in any %<library>s variant."

      def initialize(reference, config: Config.new)
        @reference = reference
        @config = config
      end

      def call
        return unless synced?

        if @reference.variant == :dynamic
          dynamic_variant_message
        else
          variant_message
        end
      end

      private

      def variant_message
        return if exists?

        matching = candidate_variants
          .reject { |variant| variant.to_s == @reference.variant.to_s }
          .select { |variant| exists?(variant) }

        message = if matching.any?
          format(
            MSG_OTHER_VARIANT,
            name: @reference.name,
            location: location,
            variants: matching.map { |variant| location(variant) }.join(", ")
          )
        else
          format(
            MSG_MISSING,
            name: @reference.name,
            location: location,
            suggestion: suggestion
          )
        end

        [message, @reference.node]
      end

      def dynamic_variant_message
        return if candidate_variants.any? { |variant| exists?(variant) }

        [
          format(MSG_ANY_VARIANT, name: @reference.name, library: @reference.library),
          @reference.node
        ]
      end

      def exists?(variant = @reference.variant)
        path = Icons::Icon::FilePath.new(
          name: @reference.name,
          library: @reference.library,
          variant: variant
        ).call

        File.exist?(path)
      rescue Icons::IconNotFound, SystemCallError
        false
      end

      def synced?
        root = library_root
        root.nil? || Dir.exist?(root)
      end

      def library_root
        return if @reference.library == :animated

        library_config = Icons.libraries[@reference.library]
        return @config.base_path.join(library_config.custom_path) if library_config.respond_to?(:custom_path)

        @config.base_path.join(@config.icons_path.to_s, @reference.library.to_s)
      end

      def candidate_variants
        return [nil] if @reference.library == :animated
        return [nil] if Icons.libraries[@reference.library].respond_to?(:custom_path)

        root = library_root
        return [nil] if root.nil? || !Dir.exist?(root)

        variants = Dir.children(root).select { |entry| File.directory?(root.join(entry)) }
        variants << nil if Dir.glob(root.join("*.svg").to_s).any?

        variants
      end

      def suggestion
        closest = closest_name(@reference.name, icon_names(@reference.variant))
        closest ? " Did you mean `#{closest}`?" : ""
      end

      def icon_names(variant)
        root = variant_root(variant)
        return [] unless root && Dir.exist?(root)

        @icon_names ||= {}
        @icon_names[root.to_s] ||= Dir.glob(root.join("*.svg").to_s).map { |path| File.basename(path, ".svg") }
      end

      def variant_root(variant)
        root = library_root
        return unless root
        return root if variant.nil? || @reference.library == :animated
        return root if Icons.libraries[@reference.library].respond_to?(:custom_path)

        root.join(variant.to_s)
      end

      def closest_name(name, candidates)
        best = candidates.filter_map do |candidate|
          [candidate, DidYouMean::Levenshtein.distance(name, candidate)]
        end.min_by(&:last)

        return unless best

        candidate, distance = best
        candidate if distance <= [name.length / 3, 2].max
      end

      def location(variant = @reference.variant)
        [@reference.library, variant].compact.join("/")
      end
    end
  end
end
