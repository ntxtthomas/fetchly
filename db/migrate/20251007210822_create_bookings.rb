class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      # Relationships (foreign keys)
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.references :sitter, foreign_key: { to_table: :users }

      # Attributes
      t.date :start_date
      t.date :end_date
      t.string :location
      t.integer :status, default: 0, null: false  # handled as enum in the model
      t.text :notes

      t.timestamps
    end
  end
end
