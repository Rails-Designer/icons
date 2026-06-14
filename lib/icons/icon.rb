# frozen_string_literal: true

require "nokogiri"

require "icons/icon/file_path"
require "icons/icon/attributes"
require "icons/icon/configurable"

class Icons::Icon
  include Icons::Icon::Configurable

  # @param name [String] The icon name
  # @param library [String, Symbol] The icon library
  # @param variant [String, Symbol, nil] The icon variant (optional)
  # @param arguments [Hash] Additional attributes including class, data, stroke_width, etc.
  #
  def initialize(name:, library:, arguments:, variant: nil)
    @config = Icons.configuration

    @name = name
    @library = library.to_sym
    @variant = (variant || set_variant)&.to_sym
    @arguments = arguments
  end

  # Returns the rendered SVG markup for the icon
  #
  # @return [String] The SVG markup as an HTML string
  #
  # @raise [Icons::IconNotFound] If the icon file does not exist
  #
  def svg
    Nokogiri::HTML::DocumentFragment.parse(File.read(file_path))
      .at_css("svg")
      .tap { |svg| attach_attributes(to: svg) }
      .to_html
  rescue Errno::ENOENT
    raise Icons::IconNotFound, error_message
  end

  private

  def file_path
    Icons::Icon::FilePath.new(name: @name, library: @library, variant: @variant).call
  end
end
