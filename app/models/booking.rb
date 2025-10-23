class Booking < ApplicationRecord
  belongs_to :owner, class_name: "User"
  belongs_to :sitter, class_name: "User", optional: true
  has_and_belongs_to_many :dogs

  enum :booking_status, { pending: 0, confirmed: 1, cancelled: 2, completed: 3 }

  def owner_display_name
    return "No Owner" unless owner
    "#{owner.first_name} #{owner.last_name[0]}."
  end

  def sitter_display_name
    return "No Sitter" unless sitter
    "#{sitter.first_name} #{sitter.last_name[0]}."
  end

  def dog_names
    return "No Dogs" unless dogs
    dogs.pluck(:name).join(", ")
  end
end
