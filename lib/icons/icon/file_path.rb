# frozen_string_literal: true

require "pathname"

module Icons
  class Icon
    class FilePath
      def initialize(name:, library:, variant:)
        @name = name
        @library = library.to_sym
        @variant = variant&.to_sym
      end

      def call
        validate_components!

        if animated_library?
          path = animated_icons_path
          raise Icons::IconNotFound if path.nil?
          return path
        end

        return custom_library_path if custom_library?

        app_path
      end

      private

      ALLOWED_CHARACTERS = /\A[a-zA-Z0-9_-]+\z/

      def validate_components!
        raise Icons::IconNotFound, @name unless safe?(@name.to_s)
        raise Icons::IconNotFound, @name unless safe?(@library.to_s)
        raise Icons::IconNotFound, @name unless @variant.nil? || @variant == :"." || safe?(@variant.to_s)
      end

      def safe?(component)
        component.match?(ALLOWED_CHARACTERS)
      end

      def animated_library?
        @library == :animated
      end

      def animated_icons_path
        # Animated icons are bundled with the gem at lib/icons/assets/animated/
        # __dir__ is lib/icons/icon, so go up one level to lib/icons
        gem_icons_dir = Pathname.new(__dir__).join("..")
        path = gem_icons_dir.join("assets", "animated", "#{@name}.svg")

        File.exist?(path) ? path : nil
      end

      def custom_library?
        Icons.libraries[@library]&.respond_to?(:custom_path)
      end

      def custom_library_path
        library_config = Icons.libraries[@library]

        Icons.config.base_path.join(library_config.custom_path, "#{@name}.svg")
      end

      def app_path
        Icons.config.base_path.join(*parts)
      end

      def parts
        [
          Icons.configuration.icons_path,
          @library.to_s,
          (@variant&.to_s unless @variant == :"."), # Don't include "." as a directory
          "#{@name}.svg"
        ].compact.reject { |p| p.to_s.empty? }
      end
    end
  end
end
