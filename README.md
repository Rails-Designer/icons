# Icons

Add any icon library to a Ruby app. Icons has first-party support for a [dozen of libraries](#first-party-libraries). It is library agnostic so it can be used with any icon library using the same interface.


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

The core gem is designed to be configured by higher-level layers but can be used directly if needed.

Example:
```ruby
Icons.configure do |config|
  config.icons_path = "app/assets/svg/icons"
  config.default_library = :feather
  config.default_variant = :outline
end

# Render an icon
icon = Icons::Icon.new(name: "check", library: "feather", arguments: { class: "text-gray-500" }, variant: "outline")
svg = icon.svg
```

The resulting SVG will include the proper attributes and the SVG content from the library’s asset path.


## First-party libraries

-   boxicons
-   feather
-   flags
-   heroicons
-   linear
-   lucide
-   phosphor
-   radix
-   sidekickicons
-   tabler
-   weather


## Libraries using Icons

- [rails_icons](https://github.com/rails-designer/rails_icons)


## Contributing

This project uses [Standard](https://github.com/testdouble/standard) for formatting Ruby code. Please make sure to run `rake` before submitting pull requests.


## License

Icons is released under the MIT License.
