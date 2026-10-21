# frozen_string_literal: true

require "icons/version"
require "icons/errors"
require "icons/libraries"
require "icons/configuration"
require "icons/configuration/custom_library"
require "icons/icon"
require "icons/sprite/reference"
require "icons/sprite"
require "icons/sync"
require "icons/prune"

module Icons
  class << self
    # @return [Configuration]
    attr_accessor :configuration

    # @yield [config] Yields the configuration object for customization
    # @yieldparam config [Configuration]
    #
    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end

    # @return [Configuration]
    #
    def config
      configuration || configure {}
    end

    # Delete synced icons that no source references.
    #
    # @return [Icons::Prune::Report]
    #
    def prune(**options)
      Prune.new(**options).call
    end
  end
end
