# frozen_string_literal: true

require "nokogiri"

require "icons/icon/file_path"
require "icons/icon/attributes"

class Icons::Icon
  def initialize(name:, library:, arguments:, variant: nil)
    @config = Icons.configuration

    @name = name
    @library = library.to_s
    @variant = (variant || set_variant).to_s
    @arguments = arguments
  end

  def svg
    raise Icons::IconNotFound, error_message unless File.exist?(file_path)

    Nokogiri::HTML::DocumentFragment.parse(File.read(file_path))
      .at_css("svg")
      .tap { |svg| attach_attributes(to: svg) }
      .to_html
  end

  private

  def set_variant
    value = @config.libraries.dig(@library.to_sym, :default_variant) ||
      @config.default_variant

    value.to_s.empty? ? nil : value
  end

  def error_message
    attributes = [
      @library,
      @variant,
      @name
    ].compact

    "Icon not found: `#{attributes.join(" / ")}`"
  end

  def file_path
    Icons::Icon::FilePath.new(name: @name, library: @library, variant: @variant).call
  end

  def attach_attributes(to:)
    Icons::Icon::Attributes
      .new(default_attributes: default_attributes, arguments: @arguments)
      .attach(to: to)
  end

  def default_attributes
    {
      "stroke-width": default(:stroke_width),
      data: default(:data),
      class: default(:css)
    }
  end

  def default(key)
    library_attributes.dig(:default, key)
  end

  def library_attributes
    keys = [@library, @variant].compact.reject { |k| k.to_s.empty? }
    @config.libraries.dig(*keys) || {}
  end
end
