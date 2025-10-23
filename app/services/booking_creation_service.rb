require "ostruct"

class BookingCreationService
  include ActiveModel::Model

  attr_accessor :dog_ids, :owner_id, :sitter_id, :start_date, :end_date, :location, :notes

  validates :dog_ids, :owner_id, :start_date, :end_date, presence: true
  validate :end_date_after_start_date
  validate :dogs_availability, if: -> { dog_ids.present? && start_date.present? && end_date.present? }
  validate :owner_exists, if: -> { owner_id.present? }
  validate :sitter_exists, if: -> { sitter_id.present? }
  validate :dogs_exist, if: -> { dog_ids.present? }

  def initialize(params = {})
    @dog_ids = Array(params[:dog_ids]).reject(&:blank?)
    @owner_id = params[:owner_id]
    @sitter_id = params[:sitter_id]
    @start_date = parse_date(params[:start_date])
    @end_date = parse_date(params[:end_date])
    @location = params[:location]
    @notes = params[:notes]
  end

  def call
    return OpenStruct.new(success?: false, errors: errors, booking: nil) unless valid?

    begin
      result = ActiveRecord::Base.transaction do
        @booking = create_booking
        send_confirmation_email
        log_booking_creation

        OpenStruct.new(success?: true, errors: [], booking: @booking)
      end
      result
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Booking creation failed: #{e.message}"
      OpenStruct.new(success?: false, errors: [e.message], booking: nil)
    rescue StandardError => e
      Rails.logger.error "Unexpected error during booking creation: #{e.message}"
      Rails.logger.error "Backtrace: #{e.backtrace}"
      OpenStruct.new(success?: false, errors: [e.message], booking: nil)
    end
  end

  private

  def create_booking
    booking = Booking.create!(
      owner_id: owner_id,
      sitter_id: sitter_id,
      start_date: start_date,
      end_date: end_date,
      location: location,
      notes: notes,
      booking_status: "pending"
    )
  
    # Associate dogs with the booking
    booking.dogs = dogs
    booking.save!
    booking
  end

  def send_confirmation_email
    # BookingMailer.confirmation_email(@booking).deliver_later
    Rails.logger.info "Confirmation email would be sent for booking #{@booking.id}"
  end

  def log_booking_creation
    dog_names = dogs.map(&:name).join(", ")
    Rails.logger.info "Booking created: ID #{@booking.id}, Dogs: #{dog_names}, Owner: #{owner.display_name}"
  end

  def end_date_after_start_date
    return unless start_date && end_date

    errors.add(:end_date, "must be after start date") if end_date <= start_date
  end

  def dogs_availability
    dog_ids.each do |dog_id|
      conflicting_bookings = Booking.joins(:dogs)
                                   .where(dogs: { id: dog_id })
                                   .where("start_date <= ? AND end_date >= ?", end_date, start_date)
                                   .where.not(booking_status: ["cancelled"])

      if conflicting_bookings.exists?
        dog_name = Dog.find(dog_id).name
        errors.add(:base, "#{dog_name} is not available for the selected dates")
      end
    end
  end

  def owner_exists
    errors.add(:owner_id, "does not exist") unless User.exists?(owner_id)
  end

  def sitter_exists
    return if sitter_id.blank?
    errors.add(:sitter_id, "does not exist") unless User.exists?(sitter_id)
  end

  def dogs_exist
    existing_dog_ids = Dog.where(id: dog_ids).pluck(:id)
    missing_dog_ids = dog_ids.map(&:to_i) - existing_dog_ids

    if missing_dog_ids.any?
      errors.add(:dog_ids, "contains non-existent dogs: #{missing_dog_ids.join(', ')}")
    end
  end

  def parse_date(date_input)
    return nil if date_input.blank?
    return date_input if date_input.is_a?(Date)

    Date.parse(date_input.to_s)
  rescue ArgumentError
    nil
  end

  def dogs
    @dogs ||= Dog.where(id: dog_ids) if dog_ids.present?
  end

  def owner
    @owner ||= User.find(owner_id) if owner_id
  end

  def sitter
    @sitter ||= User.find(sitter_id) if sitter_id
  end
end
