require "application_system_test_case"

class DogsTest < ApplicationSystemTestCase
  setup do
    @dog = dogs(:one)
  end

  test "visiting the index" do
    visit dogs_url
    assert_selector "h1", text: "Dogs"
  end

  test "should create dog" do
    visit dogs_url
    click_on "New dog"

    fill_in "Age", with: @dog.age
    fill_in "Breed", with: @dog.breed
    fill_in "Name", with: @dog.name
    fill_in "Owner", with: @dog.owner_id
    fill_in "Weight", with: @dog.weight
    click_on "Create Dog"

    assert_text "Dog was successfully created"
    click_on "Back"
  end

  test "should update Dog" do
    visit dog_url(@dog)
    click_on "Edit this dog", match: :first

    fill_in "Age", with: @dog.age
    fill_in "Breed", with: @dog.breed
    fill_in "Name", with: @dog.name
    fill_in "Owner", with: @dog.owner_id
    fill_in "Weight", with: @dog.weight
    click_on "Update Dog"

    assert_text "Dog was successfully updated"
    click_on "Back"
  end

  test "should destroy Dog" do
    visit dog_url(@dog)
    click_on "Destroy this dog", match: :first

    assert_text "Dog was successfully destroyed"
  end
end
