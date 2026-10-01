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

  def test_rejects_traversal_in_name
    assert_raises(Icons::IconNotFound) do
      Icons::Icon::FilePath.new(
        name: "../../academic-cap",
        library: "heroicons",
        variant: "outline"
      ).call
    end
  end

  def test_rejects_absolute_path_in_name
    assert_raises(Icons::IconNotFound) do
      Icons::Icon::FilePath.new(
        name: "/etc/passwd",
        library: "heroicons",
        variant: "outline"
      ).call
    end
  end

  def test_rejects_path_separator_in_name
    assert_raises(Icons::IconNotFound) do
      Icons::Icon::FilePath.new(
        name: "outline/academic-cap",
        library: "heroicons",
        variant: "outline"
      ).call
    end
  end

  def test_rejects_backslash_in_name
    assert_raises(Icons::IconNotFound) do
      Icons::Icon::FilePath.new(
        name: "academic-cap\\evil",
        library: "heroicons",
        variant: "outline"
      ).call
    end
  end

  def test_rejects_nul_byte_in_name
    assert_raises(Icons::IconNotFound) do
      Icons::Icon::FilePath.new(
        name: "academic-cap\u0000",
        library: "heroicons",
        variant: "outline"
      ).call
    end
  end

  def test_rejects_traversal_in_variant
    assert_raises(Icons::IconNotFound) do
      Icons::Icon::FilePath.new(
        name: "academic-cap",
        library: "heroicons",
        variant: "outline/../../academic-cap"
      ).call
    end
  end

  def test_rejects_traversal_in_library
    assert_raises(Icons::IconNotFound) do
      Icons::Icon::FilePath.new(
        name: "academic-cap",
        library: "../../evil",
        variant: "outline"
      ).call
    end
  end

  def test_rejects_traversal_in_animated_library_name
    assert_raises(Icons::IconNotFound) do
      Icons::Icon::FilePath.new(
        name: "../../../../../test/fixtures/app/assets/svg/icons/heroicons/outline/academic-cap",
        library: "animated",
        variant: nil
      ).call
    end
  end
end
