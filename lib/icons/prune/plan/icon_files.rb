# frozen_string_literal: true

require "pathname"

module Icons
  class Prune
    class Plan
      class IconFiles
        def initialize(icons_root:)
          @icons_root = Pathname.new(icons_root.to_s)
        end

        def each_group
          grouped_files.each do |(library, variant), paths|
            yield library, variant, paths
          end
        end

        def library_present?(library)
          Dir.exist?(@icons_root.join(library.to_s))
        end

        private

        def grouped_files
          Dir.glob(File.join(@icons_root.to_s, "**", "*.svg")).each_with_object({}) do |path, groups|
            relative = Pathname.new(path).relative_path_from(@icons_root).to_s
            parts = relative.split(File::SEPARATOR)
            next unless [2, 3].include?(parts.size)

            library = parts.first.to_sym
            variant = parts[1] if parts.size == 3

            (groups[[library, variant]] ||= []) << path
          end
        end
      end
    end
  end
end
