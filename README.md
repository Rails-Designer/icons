# Icons

Add any icon library to a Ruby app. Icons has first-party support for a [dozen of libraries](#first-party-libraries)). It is library agnostic so it can be used with any icon library using the same interface.


## Installation

Add the core gem to your Gemfile:
```ruby
gem "icons"
```

Then run:
```bash
bundle install
```


## Usage

The core gem is designed to be configured by higher-level layers (as seen with [rails_icons](https://github.com/Rails-Designer/rails_icons) but can be used directly if needed.

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
```

The resulting SVG will include the proper attributes and the SVG content from the library’s asset path.


## First-party libraries

- [Boxicons](https://railsdesigner.com/rails-icons/boxicons/) (1600+ icons)
- [Feather](https://railsdesigner.com/rails-icons/feather/) (280+ icons)
- [Flags](https://railsdesigner.com/rails-icons/flags/) (540+ icons)
- [Heroicons](https://railsdesigner.com/rails-icons/heroicons/) (300+ icons)
- [Linear](https://railsdesigner.com/rails-icons/linear/) (170+ icons)
- [Lucide](https://railsdesigner.com/rails-icons/lucide/) (1500+ icons)
- [Phosphor](https://railsdesigner.com/rails-icons/phosphor/) (9000+ icons)
- [Radix](https://railsdesigner.com/rails-icons/radix/) (300+ icons)
- [SidekickIcons](https://railsdesigner.com/rails-icons/sidekickicons/) (49 icons, complementing [Heroicons](https://railsdesigner.com/rails-icons/heroicons/))
- [Tabler](https://railsdesigner.com/rails-icons/tabler/) (5700+ icons)
- [Weather](https://railsdesigner.com/rails-icons/weather/) (215+ icons)


## Libraries using Icons

- [rails_icons](https://github.com/rails-designer/rails_icons)


## Contributing

This project uses [Standard](https://github.com/testdouble/standard) for formatting Ruby code. Please make sure to run `rake` before submitting pull requests.


## License

Icons is released under the MIT License.
