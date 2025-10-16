require "test_helper"

class BookingCreationServiceTest < ActiveSupport::TestCase
  def setup
    @owner = users(:one)
    @sitter = users(:two)
    @dog = dogs(:one)

    @valid_params = {
      dog_ids: [@dog.id],
      owner_id: @owner.id,
      sitter_id: @sitter.id,
      start_date: Date.tomorrow,
      end_date: Date.tomorrow + 3.days,
      location: "Dog Park",
      notes: "Please bring treats"
    }
  end

  test "successfully creates booking with valid parameters" do
    service = BookingCreationService.new(@valid_params)

    assert service.valid?

    result = service.call

    assert result.success?
    assert_not_nil result.booking
    assert_equal @owner.id, result.booking.owner_id
    assert_equal @sitter.id, result.booking.sitter_id
    assert_equal "pending", result.booking.booking_status
    assert_includes result.booking.dogs, @dog
  end

  test "fails validation with missing required fields" do
    service = BookingCreationService.new({})

    assert_not service.valid?
    assert_includes service.errors[:dog_ids], "can't be blank"
    assert_includes service.errors[:owner_id], "can't be blank"
    assert_includes service.errors[:start_date], "can't be blank"
    assert_includes service.errors[:end_date], "can't be blank"
  end

  test "fails validation when end date is before start date" do
    params = @valid_params.merge(
      start_date: Date.tomorrow,
      end_date: Date.today
    )

    service = BookingCreationService.new(params)

    assert_not service.valid?
    assert_includes service.errors[:end_date], "must be after start date"
  end

  test "fails validation when dog doesn't exist" do
    params = @valid_params.merge(dog_ids: [99999])

    service = BookingCreationService.new(params)

    assert_not service.valid?
    assert_includes service.errors[:dog_ids], "contains non-existent dogs: 99999"
  end

  test "fails validation when owner doesn't exist" do
    params = @valid_params.merge(owner_id: 99999)

    service = BookingCreationService.new(params)

    assert_not service.valid?
    assert_includes service.errors[:owner_id], "does not exist"
  end

  test "allows booking creation without sitter" do
    params = @valid_params.merge(sitter_id: nil)

    service = BookingCreationService.new(params)
    result = service.call

    assert result.success?
    assert_nil result.booking.sitter_id
  end

  test "fails when dog is already booked for overlapping dates" do
    # Create existing booking
    existing_booking = Booking.create!(
      owner: @owner,
      start_date: Date.tomorrow,
      end_date: Date.tomorrow + 2.days,
      booking_status: "confirmed"
    )
    existing_booking.dogs << @dog

    # Try to create overlapping booking
    service = BookingCreationService.new(@valid_params)

    assert_not service.valid?
    assert_match(/not available for the selected dates/, service.errors[:base].first)
  end

  test "allows booking when existing booking is cancelled" do
    # Create cancelled booking
    existing_booking = Booking.create!(
      owner: @owner,
      start_date: Date.tomorrow,
      end_date: Date.tomorrow + 2.days,
      booking_status: "cancelled"
    )
    existing_booking.dogs << @dog

    # Should allow new booking
    service = BookingCreationService.new(@valid_params)
    result = service.call

    assert result.success?
    assert_not_nil result.booking
  end
end
