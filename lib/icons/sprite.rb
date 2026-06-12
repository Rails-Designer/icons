# frozen_string_literal: true

module Icons
  class Sprite
    def initialize(config: Icons.configuration, icons: nil, library: nil, variant: nil)
      @config = config
      @icons = icons
      @library = library
      @variant = variant
    end

    def svg
      symbols = references.filter_map { |reference| symbol_from(reference) }

      <<~SVG
        <svg xmlns="http://www.w3.org/2000/svg" style="display: none;">
          #{symbols.join("\n  ")}
        </svg>
      SVG
    end

    private

    def references
      @icons ? override_references : configured_references
    end

    def override_references
      library = @library || @config.default_library
      variant = @variant || @config.default_variant

      @icons.map { |name| Sprite::Reference.new(name: name, library: library, variant: variant) }
    end

    def configured_references
      sprite_config = @config.sprite || {}

      sprite_config.flat_map do |library, variants|
        variants.flat_map do |variant, names|
          names.map { |name| Sprite::Reference.new(name: name, library: library, variant: variant) }
        end
      end
    end

    def symbol_from(reference)
      return unless reference.exists?

      svg_element = Nokogiri::XML(File.read(reference.file_path)).at_css("svg")
      view_box = svg_element["viewBox"] || "0 0 24 24"
      content = svg_element.children.map(&:to_s).join

      %(<symbol id="#{reference.id}" viewBox="#{view_box}">#{content}</symbol>)
    rescue Icons::IconNotFound
      warn "Icon not found: #{reference.name} from #{reference.library}/#{reference.variant}"

      nil
    end
  end
end
