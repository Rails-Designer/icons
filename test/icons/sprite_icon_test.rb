# frozen_string_literal: true

require "test_helper"
require "icons/sprite_icon"

class Icons::SpriteIconTest < Minitest::Test
  def test_returns_svg_with_use_href
    sprite_icon = Icons::SpriteIcon.new(
      name: "academic-cap",
      library: "heroicons",
      variant: :outline,
      sprite_location: nil,
      arguments: {}
    )

    assert_match(/<svg/, sprite_icon.svg)
    assert_match(%r{<use href="#heroicons_outline_academic-cap"></use>}, sprite_icon.svg)
  end

  def test_returns_svg_with_external_sprite_location
    sprite_icon = Icons::SpriteIcon.new(
      name: "academic-cap",
      library: "heroicons",
      variant: :outline,
      sprite_location: "/sprite.svg",
      arguments: {}
    )

    assert_match(%r{<use href="/sprite.svg#heroicons_outline_academic-cap"></use>}, sprite_icon.svg)
  end

  def test_applies_css_class
    sprite_icon = Icons::SpriteIcon.new(
      name: "academic-cap",
      library: "heroicons",
      variant: :outline,
      sprite_location: nil,
      arguments: {class: "size-6"}
    )

    assert_match(/class="size-6"/, sprite_icon.svg)
  end

  def test_applies_data_attributes
    sprite_icon = Icons::SpriteIcon.new(
      name: "academic-cap",
      library: "heroicons",
      variant: :outline,
      sprite_location: nil,
      arguments: {data: {controller: "swap"}}
    )

    assert_match(/data-controller="swap"/, sprite_icon.svg)
  end

  def test_applies_stroke_width
    sprite_icon = Icons::SpriteIcon.new(
      name: "academic-cap",
      library: "heroicons",
      variant: :outline,
      sprite_location: nil,
      arguments: {stroke_width: 2}
    )

    assert_match(/stroke-width="2"/, sprite_icon.svg)
  end

  def test_uses_default_variant_from_config
    Icons.configure do |config|
      config.default_variant = :outline
    end

    sprite_icon = Icons::SpriteIcon.new(
      name: "academic-cap",
      library: "heroicons",
      variant: nil,
      sprite_location: nil,
      arguments: {}
    )

    assert_match(%r{#heroicons_outline_academic-cap}, sprite_icon.svg)
  end

  def test_does_not_raise_when_icon_missing
    sprite_icon = Icons::SpriteIcon.new(
      name: "nonexistent-icon",
      library: "heroicons",
      variant: :outline,
      sprite_location: nil,
      arguments: {}
    )

    result = sprite_icon.svg
    assert_match(/<svg/, result)
  end
end