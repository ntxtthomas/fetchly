require "test_helper"

class BookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @booking = bookings(:one)
  end

  test "should get index" do
    get bookings_url
    assert_response :success
  end

  test "should get new" do
    get new_booking_url
    assert_response :success
  end

  test "should create booking" do
    user_one = users(:one)
    user_two = users(:two)
    dog_one = dogs(:one)

    assert_difference("Booking.count") do
      post bookings_url, params: { booking: {
        owner_id: user_one.id,
        sitter_id: user_two.id,
        dog_ids: [dog_one.id],
        start_date: Date.current,
        end_date: Date.current + 2.days,
        location: "Test Location",
        notes: "Test booking"
      } }
    end

    assert_redirected_to booking_url(Booking.last)
  end

  test "should show booking" do
    get booking_url(@booking)
    assert_response :success
  end

  test "should get edit" do
    get edit_booking_url(@booking)
    assert_response :success
  end

  test "should update booking" do
    patch booking_url(@booking), params: { booking: {
      location: "Updated Location",
      notes: "Updated notes"
    } }
    assert_redirected_to booking_url(@booking)
  end

  test "should destroy booking" do
    assert_difference("Booking.count", -1) do
      delete booking_url(@booking)
    end

    assert_redirected_to bookings_url
  end
end
