require "icons/configuration/animated"
require "icons/configuration/boxicons"
require "icons/configuration/feather"
require "icons/configuration/flags"
require "icons/configuration/heroicons"
require "icons/configuration/linear"
require "icons/configuration/lucide"
require "icons/configuration/phosphor"
require "icons/configuration/radix"
require "icons/configuration/sidekickicons"
require "icons/configuration/tabler"
require "icons/configuration/weather"

module Icons
  extend self

  def libraries
    {
      boxicons: Icons::Configuration::Boxicons,
      feather: Icons::Configuration::Feather,
      flags: Icons::Configuration::Flags,
      heroicons: Icons::Configuration::Heroicons,
      linear: Icons::Configuration::Linear,
      lucide: Icons::Configuration::Lucide,
      phosphor: Icons::Configuration::Phosphor,
      radix: Icons::Configuration::Radix,
      sidekickicons: Icons::Configuration::Sidekickicons,
      tabler: Icons::Configuration::Tabler,
      weather: Icons::Configuration::Weather
    }
  end
end
