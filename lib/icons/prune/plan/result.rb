# frozen_string_literal: true

module Icons
  class Prune
    class Plan
      Result = Data.define(
        :kept_paths,
        :deleted_paths,
        :library_stats,
        :skipped_libraries,
        :bytes_deleted
      )
    end
  end
end
