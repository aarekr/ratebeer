json.extract! beer, :id, :name
json.style do
  json.name beer.style
end
json.brewery do
  json.name beer.brewery.name
end
