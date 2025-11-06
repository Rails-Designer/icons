# frozen_string_literal: true

require "test_helper"

class Icons::AnimatedIconTest < Minitest::Test
  def test_faded_spinner_icon
    icon = Icons::Icon.new(name: "faded-spinner", library: :animated, arguments: {})
    
    assert icon.svg
  end

  def test_trailing_spinner_icon
    icon = Icons::Icon.new(name: "trailing-spinner", library: :animated, arguments: {})
    
    assert icon.svg
  end

  def test_fading_dots
    icon = Icons::Icon.new(name: "fading-dots", library: :animated, arguments: {})
    
    assert icon.svg
  end

  def test_bouncing_dots
    icon = Icons::Icon.new(name: "bouncing-dots", library: :animated, arguments: {})
    
    assert icon.svg
  end
end
