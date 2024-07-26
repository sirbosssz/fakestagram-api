# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

users = User.create!([
  { email: 'boss1@gmail.com', password: '12345678', username: 'boss1' },
  { email: 'boss2@gmail.com', password: '12345678', username: 'boss2' }
])

posts = Post.create([
  { image_url: 'https://example.com/image.jpg', description: 'image1', user: users.first },
  { image_url: 'https://example.com/image.jpg', description: 'image2', user: users.first },
  { image_url: 'https://example.com/image.jpg', description: 'image3', user: users.first }
])
