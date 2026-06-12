# frozen_string_literal: true

require "nokogiri"

require "icons/icon/attributes"

class Icons::SpriteIcon
  def initialize(name:, library:, arguments:, variant: nil, sprite_location: nil, config: Icons.configuration)
    @config = config

    @name = name
    @library = library.to_sym
    @variant = (variant || set_variant)&.to_sym
    @arguments = arguments
    @sprite_location = sprite_location || @config.default_sprite_location
  end

  def svg
    if @config.validate_sprite_icons
      raise Icons::IconNotFound, error_message unless reference.exists?
    end

    sprite_svg
  end

  private

  def reference
    @reference ||= Icons::Sprite::Reference.new(name: @name, library: @library, variant: @variant)
  end

  def set_variant
    value = @config.libraries.dig(@library, :default_variant) ||
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

  def sprite_svg
    sprite_href = @sprite_location.nil? ? "##{reference.id}" : "#{@sprite_location}##{reference.id}"

    svg_content = <<~SVG
      <svg><use href="#{sprite_href}"></use></svg>
    SVG

    Nokogiri::HTML::DocumentFragment.parse(svg_content)
      .at_css("svg")
      .tap { |svg| attach_attributes(to: svg) }
      .to_html
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
    }.compact
  end

  def default(key) = library_attributes.dig(:default, key)

  def library_attributes
    keys = [@library, @variant].compact

    @config.libraries.dig(*keys) || {}
  end
end