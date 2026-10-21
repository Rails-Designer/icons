# frozen_string_literal: true

module Icons
  class Prune
    # Describes one way icons are rendered outside Ruby (templates, config files).
    TextPattern = Data.define(:regexp, :library, :name, :variant)
  end
end
