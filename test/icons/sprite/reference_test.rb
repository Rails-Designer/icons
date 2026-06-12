# frozen_string_literal: true

require "test_helper"

class Icons::Sprite::ReferenceTest < Minitest::Test
  def test_id_joins_library_variant_and_name_with_underscores
    reference = Icons::Sprite::Reference.new(
      name: "check", library: :heroicons, variant: :outline
    )

    assert_equal "heroicons_outline_check", reference.id
  end

  def test_file_path_resolves_through_icons_icon_file_path
    reference = Icons::Sprite::Reference.new(
      name: "academic-cap", library: "heroicons", variant: "outline"
    )

    assert_match(%r{heroicons/outline/academic-cap\.svg\z}, reference.file_path.to_s)
  end

  def test_exists_returns_true_when_icon_file_on_disk
    reference = Icons::Sprite::Reference.new(
      name: "academic-cap", library: "heroicons", variant: "outline"
    )

    assert reference.exists?
  end

  def test_exists_returns_false_when_icon_file_missing
    reference = Icons::Sprite::Reference.new(
      name: "definitely-not-an-icon", library: "heroicons", variant: "outline"
    )

    refute reference.exists?
  end

  def test_exists_returns_false_when_library_unknown
    reference = Icons::Sprite::Reference.new(
      name: "anything", library: "library-that-does-not-exist", variant: "outline"
    )

    refute reference.exists?
  end
end
