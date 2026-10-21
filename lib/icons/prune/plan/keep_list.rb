# frozen_string_literal: true

module Icons
  class Prune
    class Plan
      class KeepList
        def initialize(references:, dynamic_icon_names:, config:)
          @references = references
          @dynamic_icon_names = dynamic_icon_names
          @config = config
        end

        def names_to_keep(library, variant)
          referenced_icon_names(library, variant)
            .union(Array(@dynamic_icon_names[library]))
            .union(configured_keep_names(library))
        end

        def library_has_evidence?(library)
          return true if @references.any? { |reference| reference.library == library }
          return true if @dynamic_icon_names[library]&.any?

          per_library_keep_names(library).any?
        end

        def skip_reason_for(library)
          return :animated if library == :animated
          return :skip_libraries if Array(@config.skip_libraries).map(&:to_sym).include?(library)
          return :custom_path if custom_path?(library)

          nil
        end

        private

        def referenced_icon_names(library, variant)
          @references.each_with_object(Set.new) do |reference, names|
            next unless reference.library == library
            next unless reference.variant == variant || reference.variant == :any

            names << reference.name
          end
        end

        def configured_keep_names(library)
          return per_library_keep_names(library) if @config.keep_icons.is_a?(Hash)

          Array(@config.keep_icons)
        end

        def per_library_keep_names(library)
          return [] unless @config.keep_icons.is_a?(Hash)

          Array(@config.keep_icons[library] || @config.keep_icons[library.to_s])
        end

        def custom_path?(library)
          Icons.libraries[library]&.respond_to?(:custom_path)
        end
      end
    end
  end
end
