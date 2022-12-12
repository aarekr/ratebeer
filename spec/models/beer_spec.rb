require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "has the name set correctly" do
    beer = Beer.new name: "Staro Brno"
    expect(beer.name).to eq("Staro Brno")
  end

  it "is saved with name, style and brewery" do
    brewery = Brewery.new name: "test", year: 2000
    expect(brewery).to be_valid
    beer = Beer.create name: "Gambrinus", style: "Lager", brewery: brewery
    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    brewery = Brewery.new name: "test", year: 2000
    beer = Beer.create name: "", style: "Lager", brewery: brewery
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    brewery = Brewery.new name: "test", year: 2000
    beer = Beer.create name: "Gambrinus", style: "", brewery: brewery
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
