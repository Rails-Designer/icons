# frozen_string_literal: true

require "test_helper"

class Icons::SpriteTest < Minitest::Test
  def test_generates_sprite_with_configured_icons
    Icons.configure do |config|
      config.sprite = {
        heroicons: {
          outline: ["academic-cap"]
        }
      }
    end

    sprite = Icons::Sprite.new
    result = sprite.svg

    assert_match(/<svg xmlns/, result)
    assert_match(/style="display: none;"/, result)
    assert_match(/<symbol id="heroicons_outline_academic-cap"/, result)
    assert_match(/viewBox/, result)
  end

  def test_generates_sprite_with_override_icons_array
    sprite = Icons::Sprite.new(icons: ["academic-cap"], library: "heroicons", variant: "outline")
    result = sprite.svg

    assert_match(/<symbol id="heroicons_outline_academic-cap"/, result)
  end

  def test_generates_empty_sprite_when_no_icons_configured
    Icons.configure do |config|
      config.sprite = {}
    end

    sprite = Icons::Sprite.new
    result = sprite.svg

    assert_match(/<svg xmlns/, result)
    refute_match(/<symbol/, result)
  end

  def test_skips_icons_that_do_not_exist
    sprite = Icons::Sprite.new(icons: ["nonexistent-icon"], library: "heroicons", variant: "outline")
    result = sprite.svg

    assert_match(/<svg xmlns/, result)
    refute_match(/<symbol/, result)
  end

  def test_generates_multiple_symbols
    Icons.configure do |config|
      config.sprite = {
        heroicons: {
          outline: ["academic-cap"],
          mini: ["academic-cap"]
        }
      }
    end

    sprite = Icons::Sprite.new
    result = sprite.svg

    assert_match(/<symbol id="heroicons_outline_academic-cap"/, result)
    assert_match(/<symbol id="heroicons_mini_academic-cap"/, result)
  end

  def test_returns_string
    sprite = Icons::Sprite.new(icons: ["academic-cap"], library: "heroicons", variant: "outline")
    result = sprite.svg

    assert_kind_of String, result
  end
end