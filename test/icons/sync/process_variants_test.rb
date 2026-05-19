# frozen_string_literal: true

require "test_helper"
require "fileutils"
require "icons/sync/process_variants"

class Icons::Sync::ProcessVariantsTest < Minitest::Test
  def test_process_applies_svg_content_transformations
    Dir.mktmpdir do |temp_directory|
      source_directory = File.join(temp_directory, "svg", "basic")

      FileUtils.mkdir_p(source_directory)
      File.write(File.join(source_directory, "test.svg"), '<svg xmlns="http://www.w3.org/2000/svg"><path d="M2 3h2v18H2z"/></svg>')

      library = { variants: { regular: "svg/basic" } }

      processor = Icons::Sync::ProcessVariants.new(temp_directory, "boxicons", library)
      processor.process

      result_file = File.join(temp_directory, "regular", "test.svg")
      assert File.exist?(result_file), "Expected SVG file to exist at #{result_file}"

      result = File.read(result_file)
      assert_includes result, 'fill="currentColor"'
    end
  end
end
