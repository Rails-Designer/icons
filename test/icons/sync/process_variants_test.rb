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

  def test_processes_only_included_variants_when_variants_is_set
    Dir.mktmpdir do |temp_directory|
      FileUtils.mkdir_p(File.join(temp_directory, "svg", "filled"))
      FileUtils.mkdir_p(File.join(temp_directory, "svg", "outline"))
      File.write(File.join(temp_directory, "svg", "filled", "test.svg"), "<svg></svg>")
      File.write(File.join(temp_directory, "svg", "outline", "test.svg"), "<svg></svg>")

      library = { variants: { filled: "svg/filled", outline: "svg/outline" } }

      processor = Icons::Sync::ProcessVariants.new(temp_directory, "tabler", library, variants: [:filled])
      processor.process

      assert File.exist?(File.join(temp_directory, "filled", "test.svg"))
      refute File.exist?(File.join(temp_directory, "outline", "test.svg"))
    end
  end

  def test_processes_all_variants_when_variants_is_nil
    Dir.mktmpdir do |temp_directory|
      FileUtils.mkdir_p(File.join(temp_directory, "svg", "filled"))
      FileUtils.mkdir_p(File.join(temp_directory, "svg", "outline"))
      File.write(File.join(temp_directory, "svg", "filled", "test.svg"), "<svg></svg>")
      File.write(File.join(temp_directory, "svg", "outline", "test.svg"), "<svg></svg>")

      library = { variants: { filled: "svg/filled", outline: "svg/outline" } }

      processor = Icons::Sync::ProcessVariants.new(temp_directory, "tabler", library)
      processor.process

      assert File.exist?(File.join(temp_directory, "filled", "test.svg"))
      assert File.exist?(File.join(temp_directory, "outline", "test.svg"))
    end
  end
end
