require "application_system_test_case"

class BeerclubsTest < ApplicationSystemTestCase
  setup do
    @beerclub = beerclubs(:one)
  end

  test "visiting the index" do
    visit beerclubs_url
    assert_selector "h1", text: "Beerclubs"
  end

  test "should create beerclub" do
    visit beerclubs_url
    click_on "New beerclub"

    fill_in "City", with: @beerclub.city
    fill_in "Founded", with: @beerclub.founded
    fill_in "Name", with: @beerclub.name
    click_on "Create Beerclub"

    assert_text "Beerclub was successfully created"
    click_on "Back"
  end

  test "should update Beerclub" do
    visit beerclub_url(@beerclub)
    click_on "Edit this beerclub", match: :first

    fill_in "City", with: @beerclub.city
    fill_in "Founded", with: @beerclub.founded
    fill_in "Name", with: @beerclub.name
    click_on "Update Beerclub"

    assert_text "Beerclub was successfully updated"
    click_on "Back"
  end

  test "should destroy Beerclub" do
    visit beerclub_url(@beerclub)
    click_on "Destroy this beerclub", match: :first

    assert_text "Beerclub was successfully destroyed"
  end
end
