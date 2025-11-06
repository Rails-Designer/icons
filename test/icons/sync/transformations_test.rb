# frozen_string_literal: true

require "test_helper"
require "icons/sync/transformations"

class Icons::Sync::TransformationsTest < Minitest::Test
  def test_delete_prefix
    result = Icons::Sync::Transformations.transform(
      "icon-test.svg",
      {delete_prefix: "icon-"}
    )

    assert_equal "test.svg", result
  end

  def test_delete_suffix
    result = Icons::Sync::Transformations.transform(
      "test-icon.svg",
      {delete_suffix: "-icon"}
    )

    assert_equal "test.svg", result
  end

  def test_delete_multiple_prefixes
    result = Icons::Sync::Transformations.transform(
      "icon-prefix-test.svg",
      {delete_prefix: ["icon-", "prefix-"]}
    )

    assert_equal "test.svg", result
  end

  def test_no_transformation
    result = Icons::Sync::Transformations.transform("test.svg", {})

    assert_equal "test.svg", result
  end
end
