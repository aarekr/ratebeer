require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("Kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ) ]
    )
    visit places_path
    fill_in('city', with: 'Kumpula')
    click_button "Search"
    expect(page).to have_content "Oljenkorsi"
  end

  it "if several are returned by API, they are shown on the page" do
    allow(BeermappingApi).to receive(:places_in).with("Kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ), 
        Place.new( name: "Old Sophie", id: 2 ),
        Place.new( name: "Bierhaus", id: 3) ]
    )
    visit places_path
    fill_in('city', with: 'Kumpula')
    click_button "Search"
    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Old Sophie"
    expect(page).to have_content "Bierhaus"
  end

  it "if none are returned by API, No locations text is shown on the page" do
    allow(BeermappingApi).to receive(:places_in).with("Kumpula").and_return( [ ] )
    visit places_path
    fill_in('city', with: 'Kumpula')
    click_button "Search"
    expect(page).to have_content "No locations in Kumpula"
  end
end
