# frozen_string_literal: true

module Icons
  class IconNotFound < StandardError
    def initialize(icon_name = nil)
      if icon_name
        super("The icon `#{icon_name}` is not available. Please check the icon name and try again.")
      else
        super("Icon not found")
      end
    end
  end

  class LibraryNotFound < StandardError
    def initialize(library_name)
      if library_name.empty?
        libraries = Icons.libraries.keys.join(", ")
        super("No libraries were specified. Please choose from: #{libraries}")
      else
        super("The library `#{library_name}` is not available. Please check the library name and try again.")
      end
    end
  end
end
