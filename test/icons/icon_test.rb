# frozen_string_literal: true

require "test_helper"

class Icons::IconTest < Minitest::Test
  def test_returns_an_icon_svg
    icon = Icons::Icon.new(name: "academic-cap", library: "heroicons", arguments: {})

    assert_match(/\A<svg.*<\/svg>\z/m, icon.svg)
  end

  def test_should_not_include_height
    icon = Icons::Icon.new(name: "academic-cap", library: "heroicons", arguments: {})

    refute_match(/height=/i, icon.svg, "SVG should not contain a 'height' attribute")
  end

  def test_returns_svg_with_custom_class
    icon = Icons::Icon.new(name: "academic-cap", library: "heroicons", arguments: {class: "size-4"})

    assert_match(/class="size-4"/, icon.svg, "SVG should contain 'class=\"size-4\"'")
  end

  def test_returns_svg_with_custom_data_attributes
    icon = Icons::Icon.new(name: "academic-cap", library: "heroicons", arguments: {data: {controller: "swap"}})

    assert_match(/data-controller="swap"/, icon.svg, "SVG should contain 'data-attributes'")
  end

  def test_returns_svg_with_custom_stroke_width
    icon = Icons::Icon.new(name: "academic-cap", library: "heroicons", arguments: {stroke_width: 3})

    assert_match(/stroke-width="3"/, icon.svg, "SVG should contain 'stroke-width=\"3\"'")
  end

  def test_parses_class_attributes
    icon = Icons::Icon.new(name: "academic-cap", library: "heroicons", arguments: {class: [{present: true, "not-present": false}]})

    assert_match(/class="present"/, icon.svg, "SVG should contain 'class=\"present\"'")
  end

  def test_setting_variant_returns_svg
    icon = Icons::Icon.new(name: "academic-cap", library: "heroicons", variant: "mini", arguments: {})

    assert icon.svg
  end

  def test_uses_library_specific_default_variant_over_global
    Icons.configure do |config|
      config.default_variant = "global variant"
      config.libraries[:heroicons][:default_variant] = "outline"
    end
    icon = Icons::Icon.new(name: "academic-cap", library: "heroicons", arguments: {})

    assert icon.svg
  end

  def test_setting_variant_as_symbol_returns_svg
    icon = Icons::Icon.new(name: "academic-cap", library: "heroicons", variant: :mini, arguments: {})

    assert icon.svg
  end

  def test_heroicons_library
    icon = Icons::Icon.new(name: "academic-cap", library: "heroicons", arguments: {})

    assert icon.svg
  end

  def test_sidekickicons_library
    icon = Icons::Icon.new(name: "arc-third", library: "sidekickicons", arguments: {})

    assert icon.svg
  end

  def test_feather_library
    icon = Icons::Icon.new(name: "activity", library: "feather", arguments: {})

    assert icon.svg
  end

  def test_radix_library
    icon = Icons::Icon.new(name: "accessibility", library: "radix", arguments: {})

    assert icon.svg
  end

  def test_boxicons_library
    icon = Icons::Icon.new(name: "abacus", library: "boxicons", arguments: {})

    assert icon.svg
  end

  def test_lucide_library
    icon = Icons::Icon.new(name: "graduation-cap", library: "lucide", arguments: {})

    assert icon.svg
  end

  def test_phosphor_library
    icon = Icons::Icon.new(name: "acorn", library: "phosphor", arguments: {})

    assert icon.svg
  end

  def test_phosphor_library_with_variant
    icon = Icons::Icon.new(name: "acorn", library: "phosphor", variant: :duotone, arguments: {})

    assert icon.svg
  end

  def test_tabler_library
    icon = Icons::Icon.new(name: "thumbs-up", library: "tabler", arguments: {})

    assert icon.svg
  end

  def test_linear_library
    icon = Icons::Icon.new(name: "alarm", library: "linear", arguments: {})

    assert icon.svg
  end

  def test_weather_library
    icon = Icons::Icon.new(name: "alien", library: "weather", arguments: {})

    assert icon.svg
  end

  def test_flags_library
    icon = Icons::Icon.new(name: "nl", library: "flags", arguments: {})

    assert icon.svg
  end

  def test_raises_icon_not_found_error
    assert_raises(Icons::IconNotFound) do
      Icons::Icon.new(name: "non-existing-icon", library: "heroicons", arguments: {}).svg
    end
  end
end
