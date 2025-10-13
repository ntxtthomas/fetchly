class CreateBookingsDogsJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_join_table :bookings, :dogs do |t|
      # t.index [:booking_id, :dog_id]
      # t.index [:dog_id, :booking_id]
    end
  end
end
