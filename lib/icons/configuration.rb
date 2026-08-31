# frozen_string_literal: true

require "pathname"
require "icons/configuration/options"

module Icons
  class Configuration
    # @return [String, nil]
    attr_accessor :default_library, :icons_path, :default_variant, :sprite, :default_sprite_location, :validate_sprite_icons

    # @return [Options]
    attr_reader :libraries

    def initialize
      @libraries = Options.new

      set_default_config
      set_libraries_config
    end

    # @deprecated Use {#icons_path} instead
    # @return [String]
    #
    def destination_path
      warn "[DEPRECATION] `destination_path` is deprecated. Use `icons_path` instead."

      @icons_path
    end

    # @deprecated Use {#icons_path=} instead
    #
    def destination_path=(value)
      warn "[DEPRECATION] `destination_path=` is deprecated. Use `icons_path=` instead."

      @icons_path = value
    end

    # @return [Pathname]
    #
    def base_path
      @base_path ||= Pathname.new(Dir.pwd)
    end

    # @param value [Pathname, String]
    #
    def base_path=(value)
      @base_path = value.is_a?(Pathname) ? value : Pathname.new(value)
    end

    # Register a custom library at configuration time.
    #
    # @param name [Symbol] The library name used in `icon "name", library: :your_name`
    # @param source [Hash, nil] Optional git source hash with `:url` and `:variants`.
    #        When provided, the library becomes syncable via `Icons::Sync.new(:your_name).now`.
    #
    # @example Add a local custom library
    #   Icons.configure do |config|
    #     config.custom_library :my_icons
    #   end
    #
    # @example Add a custom library with a git source
    #   Icons.configure do |config|
    #     config.custom_library :my_icons, source: { url: "https://github.com/user/icons.git", variants: { default: "." } }
    #   end
    #
    def custom_library(name, source: nil)
      name = name.to_sym

      library_config = CustomLibrary.new(source: source)

      Icons.register_library(name, library_config)

      @libraries[name] = library_config.config
    end

    private

    def set_default_config
      @default_library = nil
      @default_variant = nil
      @icons_path = "app/assets/svg/icons"
      @sprite = {}
      @default_sprite_location = nil
      @validate_sprite_icons = false
    end

    def set_libraries_config
      Icons.libraries.each do |name, library|
        @libraries[name] = library.config
      end

      @libraries[:animated] = Configuration::Animated.config
    end
  end
end
