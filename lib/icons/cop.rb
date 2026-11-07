# frozen_string_literal: true

require "icons/cop/source"
require "icons/cop/checker"

module Icons
  module Cop
    CallPattern = Data.define(
      :receiver,
      :method,
      :name_arg,
      :icons_arg,
      :library_arg,
      :variant_arg,
      :fixed_library,
      :default_library
    )

    Reference = Data.define(:name, :node, :library, :variant)

    class Config
      def initialize
        @config = Icons.configuration || configure
      end

      def default_library = @config.default_library
      def default_variant = @config.default_variant
      def libraries = @config.libraries
      def base_path = @config.base_path
      def icons_path = @config.icons_path

      private

      def configure
        Icons.configure {}

        Icons.configuration
      end
    end

    extend self

    # @return [Array<CallPattern>] The registered call patterns
    def call_patterns
      @call_patterns ||= default_call_patterns.dup
    end

    # Register how a wrapper helper passes icon arguments.
    #
    # @param method [Symbol] The helper method name
    # @param receiver [String, nil] The constant path the helper is called on
    # @param name [Symbol, :positional] The argument holding the icon name
    # @param icons [Symbol, nil] The argument holding an array of icon names
    # @param library [Symbol] The argument holding the library
    # @param variant [Symbol] The argument holding the variant
    # @param fixed_library [Symbol, nil] A library the helper always uses
    # @param default_library [Symbol, nil] A library used when the helper omits one
    # @return [void]
    def register_call_pattern(method:, receiver: nil, name: :positional, icons: nil, library: :library,
      variant: :variant, fixed_library: nil, default_library: nil)
      call_patterns << CallPattern.new(
        receiver: receiver,
        method: method.to_sym,
        name_arg: name,
        icons_arg: icons,
        library_arg: library,
        variant_arg: variant,
        fixed_library: fixed_library&.to_sym,
        default_library: default_library&.to_sym
      )
    end

    def reset_call_patterns!
      @call_patterns = nil
    end

    private

    def default_call_patterns
      [
        CallPattern.new(
          receiver: "Icons::Icon",
          method: :new,
          name_arg: :name,
          icons_arg: nil,
          library_arg: :library,
          variant_arg: :variant,
          fixed_library: nil,
          default_library: nil
        ),
        CallPattern.new(
          receiver: "Icons::Sprite",
          method: :new,
          name_arg: :positional,
          icons_arg: :icons,
          library_arg: :library,
          variant_arg: :variant,
          fixed_library: nil,
          default_library: nil
        )
      ]
    end
  end
end
