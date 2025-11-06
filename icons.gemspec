# frozen_string_literal: true

require_relative "lib/icons/version"

Gem::Specification.new do |spec|
  spec.name = "icons"
  spec.version = Icons::VERSION
  spec.authors = ["Rails Designer"]
  spec.email = ["devs@railsdesigner.com"]

  spec.summary = "Add any icon library to a Ruby app"
  spec.description = "Add any icon library to a Ruby app, from Heroicons, to Lucide to Phosphor (and others). Icons is library-agnostic, so you can add any library while using the same interface."
  spec.homepage = "https://railsdesigner.com/icons/"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Rails-Designer/icons/"

  spec.files = Dir["{bin,config,lib}/**/*", "Rakefile", "README.md", "icons.gemspec", "Gemfile", "Gemfile.lock"]

  spec.add_runtime_dependency "nokogiri", "~> 1.16", ">= 1.16.4"
end
