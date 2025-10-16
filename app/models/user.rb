class User < ApplicationRecord
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :dogs, foreign_key: "owner_id", class_name: "Dog"
  has_many :owned_bookings, foreign_key: "owner_id", class_name: "Booking"
  has_many :sitter_bookings, foreign_key: "sitter_id", class_name: "Booking"

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  def add_role(role_name)
    role = Role.find_or_create_by(name: role_name)
    roles << role unless roles.include?(role)
  end

  def has_role?(role_name)
    roles.exists?(name: role_name)
  end

  def display_name
    return "Unknown" if first_name.blank? || last_name.blank?
    "#{first_name} #{last_name[0]}."
  end

  # Convenience method for all bookings (as owner or sitter)
  def bookings
    Booking.where("owner_id = ? OR sitter_id = ?", id, id)
  end
end
