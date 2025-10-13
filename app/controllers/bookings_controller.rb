class BookingsController < ApplicationController
  before_action :set_booking, only: %i[show edit update destroy]
  before_action :ensure_booking_exists, only: %i[show edit update destroy]

  # GET /bookings
  def index
    @bookings = Booking.includes(:owner, :sitter).order(created_at: :desc)
  end

  # GET /bookings/:id
  def show
    # Guard clause already ensures @booking exists.
    # Could extend this with authorization (e.g., Pundit, CanCanCan) later.
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
  end

  # POST /bookings
  def create
    @booking = Booking.new(booking_params)

    if @booking.save
      redirect_to @booking, notice: "Booking was successfully created."
    else
      flash.now[:alert] = "There was a problem creating the booking."
      render :new, status: :unprocessable_entity
    end
  end

  # GET /bookings/:id/edit
  def edit
  end

  # PATCH/PUT /bookings/:id
  def update
    if @booking.update(booking_params)
      redirect_to @booking, notice: "Booking was successfully updated."
    else
      flash.now[:alert] = "There was a problem updating the booking."
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /bookings/:id
  def destroy
    if @booking.destroy
      redirect_to bookings_path, notice: "Booking was successfully destroyed."
    else
      redirect_to bookings_path, alert: "Failed to delete booking."
    end
  end

  private

  # --------------------------------------------------------------------------
  #  Strong Parameters
  # --------------------------------------------------------------------------
  def booking_params
    params.require(:booking).permit(
      :owner_id,
      :sitter_id,
      :start_date,
      :end_date,
      :location,
      :booking_status,
      :notes
    )
  end

  # --------------------------------------------------------------------------
  #  Setup & Guards
  # --------------------------------------------------------------------------
  def set_booking
    @booking = Booking.find_by(id: params[:id])
  end

  def ensure_booking_exists
    return if @booking.present?

    redirect_to bookings_path, alert: "That booking could not be found."
  end
end
