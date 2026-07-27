# Icons

Add any icon library to a Ruby app. Icons has first-party support for a [dozen of libraries](#first-party-libraries). It is library agnostic so it can be used with any icon library using the same interface.


## Installation

Add the core gem to the Gemfile:
```ruby
gem "icons"
```

Then run:
```bash
bundle install
```


## Usage

The core gem is designed to be configured by higher-level layers (as seen with [rails_icons](https://github.com/Rails-Designer/rails_icons)) but can be used directly if needed.

Example:
```ruby
Icons.configure do |config|
  config.icons_path = "app/assets/svg/icons"
  config.default_library = :lucide
  config.default_variant = :outline
end

# Sync any library from their respective (GitHub) repository
Icons::Sync.new("lucide").now

# Render an icon
icon = Icons::Icon.new(name: "check", library: "lucide", variant: "outline", arguments: { class: "text-gray-500" })
svg = icon.svg

# Generate SVG sprite for performance
sprite = Icons::Sprite.new(icons: ["check", "search"], library: "lucide", variant: "outline")
svg = sprite.svg
# => <svg xmlns="http://www.w3.org/2000/svg" style="display: none;">
#      <symbol id="lucide_outline_check" viewBox="0 0 24 24">...</symbol>
#      <symbol id="lucide_outline_search" viewBox="0 0 24 24">...</symbol>
#    </svg>

# Or configure globally
Icons.configure do |config|
  config.sprite = { lucide: { outline: ["check", "search"] } }
end

sprite = Icons::Sprite.new
sprite.svg
```

The resulting SVG will include the proper attributes and the SVG content from the library’s asset path.


## Custom libraries

Add non first-party icon libraries. The Icons gem looks for SVGs at `<icons_path>/<library_name>/<name>.svg`, so any name works without configuration.


### Zero config

Place SVGs at the expected path:
```bash
app/assets/svg/icons/my_icons/check.svg
```

Usage:
```ruby
Icons::Icon.new(name: "check", library: "my_icons", arguments: {}).svg
```


### Registered custom libraries

Use `config.custom_library` to declare a custom library with defaults:
```ruby
Icons.configure do |config|
  config.custom_library :my_icons
end
```

Then set library specific defaults:
```ruby
Icons.configure do |config|
  config.custom_library :my_icons

  config.libraries.my_icons.default.css = "size-6"
  config.libraries.my_icons.default.stroke_width = 1.5
end
```

### Custom libraries with a git source

Pass a `source:` option to make a custom library syncable from a Git repository:
```ruby
Icons.configure do |config|
  config.custom_library :my_icons, source: {
    url: "https://github.com/user/icons.git",
    variants: { default: "." }
  }
end

Icons::Sync.new(:my_icons).now
```

After syncing, `Icons::Icon.new(name: "check", library: "my_icons", arguments: {}).svg` , works just like any first party library.


## First-party libraries

- [Boxicons](https://railsdesigner.com/open-source/rails-icons/boxicons/) (1600+ icons)
- [Feather](https://railsdesigner.com/open-source/rails-icons/feather/) (280+ icons)
- [Flags](https://railsdesigner.com/open-source/rails-icons/flags/) (540+ icons)
- [Heroicons](https://railsdesigner.com/open-source/rails-icons/heroicons/) (300+ icons)
- [Hugeicons](https://railsdesigner.com/open-source/rails-icons/hugeicons/) (4600+ icons)
- [Linear](https://railsdesigner.com/open-source/rails-icons/linear/) (170+ icons)
- [Lucide](https://railsdesigner.com/open-source/rails-icons/lucide/) (1500+ icons)
- [Phosphor](https://railsdesigner.com/open-source/rails-icons/phosphor/) (9000+ icons)
- [Radix](https://railsdesigner.com/open-source/rails-icons/radix/) (300+ icons)
- [SidekickIcons](https://railsdesigner.com/open-source/rails-icons/sidekickicons/) (49 icons, complementing [Heroicons](https://railsdesigner.com/open-source/rails-icons/heroicons/))
- [Tabler](https://railsdesigner.com/open-source/rails-icons/tabler/) (5700+ icons)
- [Weather](https://railsdesigner.com/open-source/rails-icons/weather/) (215+ icons)


## Libraries using Icons

- [rails_icons](https://github.com/rails-designer/rails_icons)


## Contributing

This project uses [Standard](https://github.com/testdouble/standard) for formatting Ruby code. Please make sure to run `rake` before submitting pull requests.


## License

Icons is released under the MIT License.
