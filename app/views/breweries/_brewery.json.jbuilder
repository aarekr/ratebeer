json.extract! brewery, :id, :name, :year, :active
json.total do
  json.number brewery.beers.count
end
