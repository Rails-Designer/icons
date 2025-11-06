module IconHelper
  def icon(name, library: "heroicons", variant: nil, **arguments)
    Icons::Icon.new(name: name, library:, variant:, arguments:).svg
  end
end
