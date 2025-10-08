class RenameStatusToBookingStatusInBookings < ActiveRecord::Migration[8.0]
  def change
    rename_column :bookings, :status, :booking_status
  end
end
