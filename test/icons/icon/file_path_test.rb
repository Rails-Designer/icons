# frozen_string_literal: true

require "test_helper"

class Icons::Icon::FilePathTest < Minitest::Test
  def test_finds_icon_in_library
    file_path = Icons::Icon::FilePath.new(
      name: "academic-cap",
      library: "heroicons",
      variant: "outline"
    )
    path = file_path.call

    assert File.exist?(path)
    assert_match(/academic-cap\.svg$/, path.to_s)
  end

  def test_finds_animated_icon
    file_path = Icons::Icon::FilePath.new(
      name: "faded-spinner",
      library: "animated",
      variant: nil
    )
    path = file_path.call

    assert File.exist?(path)
    assert_match(/faded-spinner\.svg$/, path.to_s)
  end

  def test_handles_library_without_variant
    file_path = Icons::Icon::FilePath.new(
      name: "alien",
      library: "weather",
      variant: "."
    )
    path = file_path.call

    assert File.exist?(path)
  end
end
