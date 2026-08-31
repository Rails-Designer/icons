# frozen_string_literal: true

module Icons
  class IconNotFound < StandardError
    def initialize(icon_name = nil)
      if icon_name
        super("The icon `#{icon_name}` is not available. Check the icon name and try again.")
      else
        super("Icon not found")
      end
    end
  end

  class LibraryNotFound < StandardError
    def initialize(library_name = nil)
      if library_name
        super("The library `#{library_name}` is not available. Check the library name and try again.")
      else
        libraries = Icons.libraries.keys.join(", ")
        super("No libraries were specified. Choose from: #{libraries}")
      end
    end
  end
end
