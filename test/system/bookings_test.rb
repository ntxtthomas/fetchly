require "application_system_test_case"

class BookingsTest < ApplicationSystemTestCase
  setup do
    @booking = bookings(:one)
  end

  test "visiting the index" do
    visit bookings_url
    assert_selector "h1", text: "Bookings"
  end

  test "should create booking" do
    visit bookings_url
    click_on "New booking"

    # Fill out the required fields
    select users(:one).email, from: "booking_owner_id"
    select users(:two).email, from: "booking_sitter_id"

    # Select at least one dog (using checkbox)
    check dogs(:one).name

    fill_in "booking_start_date", with: Date.current
    fill_in "booking_end_date", with: Date.current + 2.days
    fill_in "booking_location", with: "Test Location"
    fill_in "booking_notes", with: "Test booking notes"

    click_on "Create Booking"

    assert_text "Booking was successfully created"
    click_on "Back"
  end

  test "should update Booking" do
    visit booking_url(@booking)
    click_on "Edit this booking", match: :first

    # Update some fields
    fill_in "booking_location", with: "Updated Location"
    fill_in "booking_notes", with: "Updated notes"

    click_on "Update Booking"

    assert_text "Booking was successfully updated"
    click_on "Back"
  end

  test "should destroy Booking" do
    visit booking_url(@booking)
    click_on "Destroy this booking", match: :first

    assert_text "Booking was successfully destroyed"
  end
end
