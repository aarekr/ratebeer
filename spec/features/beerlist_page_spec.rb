require 'rails_helper'

describe "Beerlist page" do
  before :all do
    Capybara.register_driver :chrome do |app|
      Capybara::Selenium::Driver.new app, browser: :chrome,
        options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu])
    end
    Capybara.javascript_driver = :chrome
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name: "Koff")
    @brewery2 = FactoryBot.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryBot.create(:brewery, name: "Ayinger")
    @style1 = "Lager" # Style.create name: "Lager"
    @style2 = "Rauchbier" # Style.create name: "Rauchbier"
    @style3 = "Weizen" # Style.create name: "Weizen"
    @beer1 = FactoryBot.create(:beer, name: "Nikolai", brewery: @brewery1, style:@style1)
    @beer2 = FactoryBot.create(:beer, name: "Fastenbier", brewery:@brewery2, style:@style2)
    @beer3 = FactoryBot.create(:beer, name: "Lechte Weisse", brewery:@brewery3, style:@style3)
  end

  it "shows one known beer", js:true do
    visit beerlist_path
    # find('table').find('tr:nth-child(2)')
    expect(page).to have_content "Nikolai"
  end

  it "shows beers in alphabetical order", js:true do
    visit beerlist_path
    expect(page).to have_content("Beers")
    expect(find('#beertable').first('.tablerow')).to have_content('Fastenbier')
    expect(page.all('#beertable tr').count).to eq(4)
    expect(page.all('#beertable tr')[1]).to have_content('Fastenbier Rauchbier Schlenkerla')
    expect(page.all('#beertable tr')[2]).to have_content('Lechte Weisse Weizen Ayinger')
    expect(page.all('#beertable tr')[3]).to have_content('Nikolai Lager Koff')
  end
end
