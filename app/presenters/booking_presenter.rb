class BookingPresenter < SimpleDelegator
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::TagHelper
  include Rails.application.routes.url_helpers

  def initialize(booking, view_context = nil)
    super(booking)
    @view_context = view_context
  end

  def status_badge
    content_tag :span, status_display, class: "badge #{status_badge_class}"
  end

  def owner_link
    if @view_context
      @view_context.link_to(owner_name, owner_path, class: "text-decoration-none")
    else
      owner_name
    end
  end

  def sitter_link
    return "No sitter assigned" unless sitter

    if @view_context
      @view_context.link_to(sitter_name, sitter_path, class: "text-decoration-none")
    else
      sitter_name
    end
  end

  def time_until_start
    return "Booking has started" if start_date <= Date.current
    return "Dates not set" unless start_date

    "Starts in #{distance_of_time_in_words(Date.current, start_date)}"
  end

  def booking_summary
    "#{duration_text} in #{location_display} (#{status_display})"
  end

  def stimulus_controller_data
    {
      controller: "booking",
      booking_id_value: id,
      booking_status_value: booking_status,
      booking_duration_value: duration_in_days
    }
  end

  private

  def owner_name
    "#{owner.first_name} #{owner.last_name}"
  end

  def sitter_name
    return nil unless sitter
    "#{sitter.first_name} #{sitter.last_name}"
  end

  def owner_path
    # Assuming you'll have user routes
    "/users/#{owner.id}"
  end

  def sitter_path
    "/users/#{sitter.id}"
  end

  def duration_text
    days = duration_in_days
    return "No duration set" if days.zero?

    days == 1 ? "1 day" : "#{days} days"
  end

  def status_badge_class
    case booking_status
    when "pending" then "bg-warning text-dark"
    when "confirmed" then "bg-success"
    when "cancelled" then "bg-danger"
    when "completed" then "bg-info"
    else "bg-secondary"
    end
  end

  def status_display
    booking_status.humanize
  end

  def duration_in_days
    return 0 unless start_date && end_date
    (end_date - start_date).to_i + 1
  end

  def location_display
    location.present? ? location : "Location TBD"
  end

  # Access the original booking object
  def booking
    __getobj__
  end
end
