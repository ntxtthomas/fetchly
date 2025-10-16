# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

require "faker"

puts "🌱 Seeding database..."

# --- Clear existing data ---
UserRole.delete_all
Role.delete_all
User.delete_all

# --- Create Roles ---
roles = %w[admin support sitter owner]
roles.each { |role| Role.create!(name: role) }
puts "✅ Created #{Role.count} roles."

# --- Create Users ---
20.times do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    telephone: Faker::PhoneNumber.cell_phone,
    street_address: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    zip: Faker::Address.zip,
    active: [true, false].sample
  )
end
puts "✅ Created #{User.count} users."

# --- Assign Roles (many-to-many) ---
User.all.each do |user|
  # each user gets between 1 and 2 random roles
  assigned_roles = Role.order("RANDOM()").limit(rand(1..2))
  assigned_roles.each do |role|
    UserRole.create!(user: user, role: role)
  end
end

puts "✅ Assigned roles to users."

# --- Clear existing Dog data ---
Dog.delete_all

# --- Create Dogs ---
# Get all users who can be owners (have owner role or just pick random users)
owners = User.joins(:roles).where(roles: { name: 'owner' })
owners = User.all if owners.empty? # fallback if no owners exist

dog_breeds = [
  "Golden Retriever", "Labrador Retriever", "German Shepherd", "French Bulldog",
  "Bulldog", "Poodle", "Beagle", "Rottweiler", "Yorkshire Terrier", "Dachshund",
  "Siberian Husky", "Great Dane", "Chihuahua", "Border Collie", "Australian Shepherd",
  "Boxer", "Cocker Spaniel", "Boston Terrier", "Shih Tzu", "Pomeranian"
]

30.times do
  Dog.create!(
    name: Faker::Creature::Dog.name,
    breed: dog_breeds.sample,
    age: rand(1..15),
    weight: "#{rand(5..120)} lbs",
    owner: owners.sample
  )
end

puts "✅ Created #{Dog.count} dogs."
puts "🎉 Seeding complete!"
