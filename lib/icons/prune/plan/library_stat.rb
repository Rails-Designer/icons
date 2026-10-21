# frozen_string_literal: true

module Icons
  class Prune
    class Plan
      LibraryStat = Data.define(:library, :variant, :kept_icon_count, :deleted_icon_count, :bytes_deleted)
    end
  end
end
