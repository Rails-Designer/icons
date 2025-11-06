# frozen_string_literal: true

require "pathname"
require "icons/configuration/options"

module Icons
  class Configuration
    attr_accessor :default_library, :icons_path, :default_variant
    attr_reader :libraries

    def initialize
      @libraries = Options.new

      set_default_config
      set_libraries_config
    end

    def destination_path
      warn "[DEPRECATION] `destination_path` is deprecated. Use `icons_path` instead."

      @icons_path
    end

    def destination_path=(value)
      warn "[DEPRECATION] `destination_path=` is deprecated. Use `icons_path=` instead."

      @icons_path = value
    end

    def base_path
      @base_path ||= Pathname.new(Dir.pwd)
    end

    def base_path=(value)
      @base_path = value.is_a?(Pathname) ? value : Pathname.new(value)
    end

    private

    def set_default_config
      @default_library = nil
      @default_variant = nil
      @icons_path = "app/assets/svg/icons"
    end

    def set_libraries_config
      Icons.libraries.each do |name, library|
        @libraries[name] = library.config
      end

      @libraries[:animated] = Configuration::Animated.config
    end
  end
end
