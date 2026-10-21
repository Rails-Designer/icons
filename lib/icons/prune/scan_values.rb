# frozen_string_literal: true

module Icons
  class Prune
    # A file that could not be parsed or read.
    ParseFailure = Data.define(:path, :message)

    # References and evidence collected from one source file.
    FileScan = Data.define(
      :references,
      :dynamic_libraries,
      :file_literals,
      :declaration_literals,
      :all_libraries_dynamic
    )

    # The complete result of scanning an application.
    Scan = Data.define(:references, :dynamic_icon_names, :parse_failures)
  end
end
