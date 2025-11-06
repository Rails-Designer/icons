# frozen_string_literal: true

require "test_helper"

class Icons::Icon::AttributesTest < Minitest::Test
  def test_merges_default_and_custom_attributes
    svg = Nokogiri::HTML::DocumentFragment.parse("<svg></svg>").at_css("svg")

    attributes = Icons::Icon::Attributes.new(
      default_attributes: {class: "default"},
      arguments: {class: "custom"}
    )

    attributes.attach(to: svg)
    assert_equal "custom", svg[:class]
  end

  def test_handles_class_as_array
    svg = Nokogiri::HTML::DocumentFragment.parse("<svg></svg>").at_css("svg")

    attributes = Icons::Icon::Attributes.new(
      default_attributes: {},
      arguments: {class: ["one", "two"]}
    )

    attributes.attach(to: svg)
    assert_equal "one two", svg[:class]
  end

  def test_handles_class_as_hash
    svg = Nokogiri::HTML::DocumentFragment.parse("<svg></svg>").at_css("svg")

    attributes = Icons::Icon::Attributes.new(
      default_attributes: {},
      arguments: {class: {active: true, inactive: false}}
    )

    attributes.attach(to: svg)
    assert_equal "active", svg[:class]
  end

  def test_handles_nested_hash_attributes
    svg = Nokogiri::HTML::DocumentFragment.parse("<svg></svg>").at_css("svg")

    attributes = Icons::Icon::Attributes.new(
      default_attributes: {},
      arguments: {data: {controller: "test", action: "click"}}
    )

    attributes.attach(to: svg)
    assert_equal "test", svg[:"data-controller"]
    assert_equal "click", svg[:"data-action"]
  end

  def test_converts_underscores_to_hyphens
    svg = Nokogiri::HTML::DocumentFragment.parse("<svg></svg>").at_css("svg")

    attributes = Icons::Icon::Attributes.new(
      default_attributes: {},
      arguments: {stroke_width: "2"}
    )

    attributes.attach(to: svg)
    assert_equal "2", svg[:"stroke-width"]
  end
end
