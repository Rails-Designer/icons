# frozen_string_literal: true

require "icons/version"
require "icons/errors"
require "icons/libraries"
require "icons/configuration"
require "icons/icon"
require "icons/sync"

module Icons
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end

    def config
      configuration || configure {}
    end
  end
end
