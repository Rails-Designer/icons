require "icons/configuration/animated"
require "icons/configuration/boxicons"
require "icons/configuration/feather"
require "icons/configuration/flags"
require "icons/configuration/heroicons"
require "icons/configuration/hugeicons"
require "icons/configuration/linear"
require "icons/configuration/lucide"
require "icons/configuration/phosphor"
require "icons/configuration/radix"
require "icons/configuration/sidekickicons"
require "icons/configuration/tabler"
require "icons/configuration/weather"

module Icons
  extend self

  BUILT_IN_LIBRARIES = {
    boxicons: Icons::Configuration::Boxicons,
    feather: Icons::Configuration::Feather,
    flags: Icons::Configuration::Flags,
    heroicons: Icons::Configuration::Heroicons,
    hugeicons: Icons::Configuration::Hugeicons,
    linear: Icons::Configuration::Linear,
    lucide: Icons::Configuration::Lucide,
    phosphor: Icons::Configuration::Phosphor,
    radix: Icons::Configuration::Radix,
    sidekickicons: Icons::Configuration::Sidekickicons,
    tabler: Icons::Configuration::Tabler,
    weather: Icons::Configuration::Weather
  }.freeze

  # @return [Hash{Symbol => Class}] A map of library names to their configuration classes
  #
  def libraries
    BUILT_IN_LIBRARIES.merge(@registered_libraries || {})
  end

  # Register a custom library for use with the icons gem.
  #
  # @param name [Symbol] The library name
  # @param library_module [Module, Object] A configuration module or object
  #        that responds to `.config` and optionally `.source` and `.custom_path`
  #
  def register_library(name, library_module)
    @registered_libraries ||= {}

    @registered_libraries[name.to_sym] = library_module
  end

  def reset_registered_libraries
    @registered_libraries = {}
  end
end
