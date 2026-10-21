# frozen_string_literal: true

module Icons
  class Prune
    class Registry
      DEFAULT_CALL_PATTERNS = [
        CallPattern.new(
          receiver: "Icons::Icon",
          method: :new,
          name_arg: :name,
          icons_arg: nil,
          library_arg: :library,
          variant_arg: :variant,
          fixed_library: nil,
          default_library: nil
        ),
        CallPattern.new(
          receiver: "Icons::Sprite",
          method: :new,
          name_arg: :positional,
          icons_arg: :icons,
          library_arg: :library,
          variant_arg: :variant,
          fixed_library: nil,
          default_library: nil
        )
      ].freeze

      class << self
        def call_patterns
          @call_patterns ||= DEFAULT_CALL_PATTERNS.dup
        end

        def text_patterns
          @text_patterns ||= []
        end

        def register_call_pattern(method:, receiver: nil, name: :positional, icons: nil, library: :library,
          variant: :variant, fixed_library: nil, default_library: nil)
          call_patterns << CallPattern.new(
            receiver: receiver,
            method: method.to_sym,
            name_arg: name,
            icons_arg: icons,
            library_arg: library,
            variant_arg: variant,
            fixed_library: fixed_library&.to_sym,
            default_library: default_library&.to_sym
          )
        end

        def register_text_pattern(regexp, library:, name:, variant: nil)
          text_patterns << TextPattern.new(regexp: regexp, library: library, name: name, variant: variant)
        end

        def reset_patterns!
          @call_patterns = nil
          @text_patterns = nil
        end
      end
    end
  end
end
