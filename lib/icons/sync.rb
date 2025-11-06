# frozen_string_literal: true

require "fileutils"
require "icons/sync/process_variants"

module Icons
  class Sync
    def initialize(name)
      raise "[Icons] Not a valid library" if Icons.libraries.keys.exclude?(name.to_sym)

      @name = name
      @library = Icons.libraries.fetch(name.to_sym).source
      @temp_directory = File.join(temp_directory_root, name)
    end

    def now
      clone_repository
      process_variants
      remove_non_svg_files

      move_library

      purge_temp_directory
    rescue => error
      puts "[Icons] Failed to sync icons: #{error.message}"

      post_error_clean_up

      raise
    end

    private

    def temp_directory_root
      Icons.config.base_path.join("tmp/icons")
    end

    def clone_repository
      raise "[Icons] Failed to clone repository" unless system("git clone '#{@library[:url]}' '#{@temp_directory}'")

      puts "[Icons] '#{@name}' repository cloned"
    end

    def process_variants
      Sync::ProcessVariants.new(@temp_directory, @name, @library).process
    end

    def remove_non_svg_files
      require "pathname"

      Pathname.glob("#{@temp_directory}/**/*")
        .select { |path| path.file? && path.extname != ".svg" }
        .each(&:delete)

      puts "[Icons] Non-SVG files removed"
    end

    def move_library
      destination = File.join(Icons.configuration.icons_path, @name)

      FileUtils.mkdir_p(destination)
      FileUtils.mv(Dir.glob("#{@temp_directory}/*"), destination, force: true)

      puts "[Icons] Synced '#{@name}' library #{%w[😃 🎉 ✨].sample}"
    end

    def purge_temp_directory
      FileUtils.rm_rf(temp_directory_root)
    end

    def post_error_clean_up
      print "Do you want to remove the temp files? ('#{@temp_directory}') [y/n]: "
      response = $stdin.gets.chomp.downcase

      if response == "y" || response == "yes"
        puts "[Icons] Cleaning up…"
        FileUtils.rm_rf(@temp_directory)
      else
        puts "[Icons] Keeping files at: '#{@temp_directory}'"
      end
    end
  end
end
