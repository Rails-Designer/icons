# frozen_string_literal: true

require "fileutils"
require "json"

module Icons
  class Prune
    class Plan
      class DeletionManifest
        def initialize(config:)
          @config = config
        end

        def write(paths)
          path = @config.base_path.join("tmp/icons-prune.json")

          FileUtils.mkdir_p(path.dirname)
          File.write(path, JSON.pretty_generate(paths))
        end
      end
    end
  end
end
