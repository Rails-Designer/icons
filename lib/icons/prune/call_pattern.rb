# frozen_string_literal: true

module Icons
  class Prune
    # Describes one way icons are rendered in Ruby source.
    CallPattern = Data.define(
      :receiver,
      :method,
      :name_arg,
      :icons_arg,
      :library_arg,
      :variant_arg,
      :fixed_library,
      :default_library
    )
  end
end
