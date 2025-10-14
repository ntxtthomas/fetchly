class Booking < ApplicationRecord
  belongs_to :owner, class_name: "User"
  belongs_to :sitter, class_name: "User", optional: true
  has_and_belongs_to_many :dogs

  enum :booking_status, { pending: 0, confirmed: 1, cancelled: 2, completed: 3 }
end
