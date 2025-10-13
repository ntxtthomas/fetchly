class Dog < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_and_belongs_to_many :bookings  # This requires a join table
end
