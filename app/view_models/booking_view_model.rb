class BookingViewModel
  def initialize(booking)
    @booking = booking
  end

  def status_badge_class
    case @booking.booking_status
    when "pending" then "badge-warning"
    when "confirmed" then "badge-success"
    when "cancelled" then "badge-danger"
    when "completed" then "badge-info"
    else "badge-secondary"
    end
  end

  def status_display
    @booking.booking_status.humanize
  end

  def duration_in_days
    return 0 unless @booking.start_date && @booking.end_date
    (@booking.end_date - @booking.start_date).to_i + 1
  end

  def formatted_date_range
    return "Dates TBD" unless @booking.start_date && @booking.end_date

    if @booking.start_date.year == @booking.end_date.year
      "#{@booking.start_date.strftime('%b %d')} - #{@booking.end_date.strftime('%b %d, %Y')}"
    else
      "#{@booking.start_date.strftime('%b %d, %Y')} - #{@booking.end_date.strftime('%b %d, %Y')}"
    end
  end

  def display_title
    sitter_name = @booking.sitter&.first_name || "Available Sitter"
    "#{@booking.owner.first_name}'s booking with #{sitter_name}"
  end

  def location_display
    @booking.location.present? ? @booking.location : "Location TBD"
  end

  def can_be_cancelled?
    @booking.pending? || @booking.confirmed?
  end

  def stimulus_data_attributes
    {
      booking_id: @booking.id,
      status: @booking.booking_status,
      duration: duration_in_days
    }
  end

  # Delegate essential methods to the booking
  def id
    @booking.id
  end

  def to_param
    @booking.to_param
  end

  private

  attr_reader :booking
end
