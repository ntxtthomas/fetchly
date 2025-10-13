class Dog < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_and_belongs_to_many :bookings  # This requires a join table

  def owner_display_name
    return "No Owner" unless owner
    "#{owner.first_name} #{owner.last_name[0]}."
  end
end
