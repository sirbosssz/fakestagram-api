require "rails_helper"

RSpec.describe "Posts", type: :request do
    before do
      users = User.create!([
        { email: 'boss1@gmail.com', password: '12345678', username: 'boss1' },
        { email: 'boss2@gmail.com', password: '12345678', username: 'boss2' }
      ])
      Post.create([
        { image_url: 'https://example.com/image.jpg', description: 'image1', user: users.first },
        { image_url: 'https://example.com/image.jpg', description: 'image2', user: users.first },
        { image_url: 'https://example.com/image.jpg', description: 'image3', user: users.first }
      ])
    end

    scenario "Get all posts and checks the array length" do
      get "http://localhost:3000/api/posts"
      expect(response).to have_http_status(:success)
      posts = JSON.parse(response.body)
      expect(posts.length).to eq(3)
  end
end
