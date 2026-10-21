# frozen_string_literal: true

module Icons
  class Prune
    # A single icon reference found in source. `variant` is a String, nil, or
    # :any when the variant is chosen at runtime.
    Reference = Data.define(:library, :variant, :name)
  end
end
