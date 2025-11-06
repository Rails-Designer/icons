# frozen_string_literal: true

require "test_helper"

class Icons::ErrorsTest < Minitest::Test
  def test_icon_not_found_with_name
    error = Icons::IconNotFound.new("test-icon")

    assert_match(/test-icon/, error.message)
  end

  def test_icon_not_found_without_name
    error = Icons::IconNotFound.new

    assert_equal "Icon not found", error.message
  end

  def test_library_not_found_with_empty_name
    error = Icons::LibraryNotFound.new("")

    assert_match(/No libraries were specified/, error.message)
  end

  def test_library_not_found_with_name
    error = Icons::LibraryNotFound.new("fake-library")

    assert_match(/fake-library/, error.message)
  end
end
