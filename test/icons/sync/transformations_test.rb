# frozen_string_literal: true

require "test_helper"
require "icons/sync/transformations"

class Icons::Sync::TransformationsTest < Minitest::Test
  def test_delete_prefix
    result = Icons::Sync::Transformations.transform(
      "icon-test.svg",
      { filenames: { delete_prefix: "icon-" } }
    )

    assert_equal "test.svg", result
  end

  def test_delete_suffix
    result = Icons::Sync::Transformations.transform(
      "test-icon.svg",
      { filenames: { delete_suffix: "-icon" } }
    )

    assert_equal "test.svg", result
  end

  def test_delete_multiple_prefixes
    result = Icons::Sync::Transformations.transform(
      "icon-prefix-test.svg",
      { filenames: { delete_prefix: ["icon-", "prefix-"] } }
    )

    assert_equal "test.svg", result
  end

  def test_no_transformation
    result = Icons::Sync::Transformations.transform("test.svg", {})

    assert_equal "test.svg", result
  end

  def test_svg_set_attribute
    svg_content = '<svg xmlns="http://www.w3.org/2000/svg"><path d="M2 3h2v18H2z"/></svg>'

    Tempfile.create(["test", ".svg"]) do |file|
      file.write(svg_content)
      file.close

      Icons::Sync::Transformations.transform_svg(
        file.path,
        [{ element: "path", action: :set_attribute, attribute: "fill", value: "currentColor" }]
      )

      result = File.read(file.path)
      assert_includes result, 'fill="currentColor"'
    end
  end

  def test_svg_set_attribute_preserves_existing
    svg_content = '<svg xmlns="http://www.w3.org/2000/svg"><path fill="blue" d="M2 3h2v18H2z"/></svg>'

    Tempfile.create(["test", ".svg"]) do |file|
      file.write(svg_content)
      file.close

      Icons::Sync::Transformations.transform_svg(
        file.path,
        [{ element: "path", action: :set_attribute, attribute: "fill", value: "currentColor" }]
      )

      result = File.read(file.path)
      assert_includes result, 'fill="currentColor"'
      refute_includes result, 'fill="blue"'
    end
  end
end
