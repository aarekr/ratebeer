require 'rails_helper'

include Helpers

describe "Breweries page" do
  it "should not have any before been created" do
    visit breweries_path
    expect(page).to have_content 'Breweries'
    expect(page).to have_content 'Number of active breweries: 0'
    expect(page).to have_content 'Number of retired breweries: 0'
  end

  it "a new brewery can be created via 'New brewery' link" do
    FactoryBot.create :user
    sign_in(username: "Pekka", password: "Foobar1")
    visit breweries_path
    expect(page).to have_link 'New brewery'
    click_link('New brewery')
    fill_in('brewery_name', with: 'Urquell')
    fill_in('brewery_year', with: '1842')
    expect{
      click_button "Submit"
    }.to change{Brewery.count}.from(0).to(1)
  end

  describe "when breweries exists" do
    before :each do
      # jotta muuttuja näkyisi it-lohkoissa, tulee sen nimen alkaa @-merkillä
      @breweries = ["Koff", "Karjala", "Schlenkerla"]
      year = 1896
      @breweries.each do |brewery_name|
        FactoryBot.create(:brewery, name: brewery_name, year: year += 1)
      end
      visit breweries_path
    end

    it "lists the breweries and their total number" do
      expect(page).to have_content "Number of active breweries: 0"
      expect(page).to have_content "Number of retired breweries: #{@breweries.count}"
      expect(page).to have_content "No ratings!"
      @breweries.each do |brewery_name|
        expect(page).to have_content brewery_name
      end
    end

    it "allows user to navigate to page of a Brewery" do
      click_link "Koff"
      expect(page).to have_content "Koff"
      expect(page).to have_content "Established in 1897"
    end
  end
end
