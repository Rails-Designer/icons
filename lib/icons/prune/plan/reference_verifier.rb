# frozen_string_literal: true

module Icons
  class Prune
    class Plan
      class ReferenceVerifier
        def initialize(references:, icon_files:, config:)
          @references = references
          @icon_files = icon_files
          @config = config
        end

        def missing_references
          @missing_references ||= expected_references.reject { |reference| available?(reference) }
        end

        private

        def expected_references
          @references.select do |reference|
            reference.variant != :any &&
              reference.library != :animated &&
              !custom_path?(reference.library) &&
              @icon_files.library_present?(reference.library)
          end.uniq
        end

        def available?(reference)
          path = path_for(reference)

          path && File.exist?(path)
        end

        def path_for(reference)
          Icons::Icon::FilePath.new(
            name: reference.name,
            library: reference.library,
            variant: reference.variant,
            config: @config
          ).call
        rescue Icons::IconNotFound
          nil
        end

        def custom_path?(library)
          Icons.libraries[library]&.respond_to?(:custom_path)
        end
      end
    end
  end
end
