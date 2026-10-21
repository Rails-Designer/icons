# frozen_string_literal: true

require "fileutils"
require "json"
require "pathname"
require "tmpdir"

module PruneHelper
  def setup
    super

    @prune_root = Pathname.new(Dir.mktmpdir)

    Icons.config.base_path = @prune_root
    Icons.config.icons_path = "icons"
    Icons.config.default_library = :lucide
    Icons.config.default_variant = nil
    Icons::Prune.reset_patterns!
  end

  def teardown
    Icons::Prune.reset_patterns!
    FileUtils.remove_entry(@prune_root) if @prune_root&.exist?

    super
  end

  def write_source(relative_path, content)
    path = @prune_root.join(relative_path)
    FileUtils.mkdir_p(path.dirname)
    File.write(path, content)
    path
  end

  def write_icon(library, variant, name)
    directory = @prune_root.join("icons", library.to_s)
    directory = directory.join(variant.to_s) unless variant.nil?
    FileUtils.mkdir_p(directory)
    File.write(directory.join("#{name}.svg"), "<svg xmlns=\"http://www.w3.org/2000/svg\"></svg>")
  end

  def icon_path(library, variant, name)
    directory = @prune_root.join("icons", library.to_s)
    directory = directory.join(variant.to_s) unless variant.nil?
    directory.join("#{name}.svg")
  end

  def prune(dry_run: true, **options)
    Icons.prune(dry_run: dry_run, **options)
  end

  def deleted_names(report)
    report.deleted_icon_names.sort
  end
end
