require "rails_helper"

RSpec.describe "Posts", type: :request do
  before do
    users = User.create!([
      { email: 'boss1@gmail.com', password: '12345678', username: 'boss1' },
      { email: 'boss2@gmail.com', password: '12345678', username: 'boss2' },
      { email: 'boss3@gmail.com', password: '12345678', username: 'boss3' }
    ])
    Post.create([
      { image_url: 'https://example.com/image.jpg', description: 'image1', user: users.first },
      { image_url: 'https://example.com/image.jpg', description: 'image2', user: users.first },
      { image_url: 'https://example.com/image.jpg', description: 'image3', user: users[1] }
    ])

    @current_user = User.find_by_email("boss1@gmail.com")
  end

  describe "index function," do
    it "render all posts" do
      get "http://localhost:3000/api/posts"
      expect(response).to have_http_status(:success)

      posts = JSON.parse(response.body)
      expect(posts.length).to eq(3)
    end
  end

  describe "by_user function," do
    let(:headers) { { "Authorization" => "Bearer #{@current_user.jwt}" } }
    it "render posts by user that have post" do
      get "http://localhost:3000/api/posts/my", headers: headers
      expect(response).to have_http_status(:success)

      posts = JSON.parse(response.body)
      expect(posts.length).to eq(2)
    end

    it "render posts by user that not have post" do
      user = User.find_by_email("boss3@gmail.com")

      get "http://localhost:3000/api/posts/my",
        headers: { "Authorization" => "Bearer #{user.jwt}" }
      expect(response).to have_http_status(:success)

      posts = JSON.parse(response.body)
      expect(posts.length).to eq(0)
    end
  end

  describe "create function," do
    let(:headers) { { "Authorization" => "Bearer #{@current_user.jwt}" } }

    let(:post_params) { { post: { image_url: "https://example.com/image.jpg", description: "image-new" } } }
    let(:post_description_only_params) { { post: { description: "image-new" } } }
    let(:post_image_only_params) { { post: { image_url: "https://example.com/image.jpg" } } }

    it "create post successfully" do
      post "http://localhost:3000/api/posts", params: post_params, headers: headers
      expect(response).to have_http_status(:success)

      posts = JSON.parse(response.body)
      expect(posts["description"]).to eq("image-new")
    end

    it "create post successfully if params not have description" do
      post "http://localhost:3000/api/posts", params: post_image_only_params, headers: headers
      expect(response).to have_http_status(:success)

      posts = JSON.parse(response.body)
      expect(posts["description"]).to eq(nil)
      expect(posts["image_url"]).to eq("https://example.com/image.jpg")
    end

    it "throw error if params not have image_url" do
      post "http://localhost:3000/api/posts", params: post_description_only_params, headers: headers
      expect(response).to have_http_status(:bad_request)

      posts = JSON.parse(response.body)
      expect(posts["error"]).to eq("image_url is required")
    end
  end

  describe "show function," do
    it "get post by id if exists" do
      example_post = Post.all.first
      id = example_post.id.to_s

      get "http://localhost:3000/api/posts/" + id
      expect(response).to have_http_status(:success)

      post = JSON.parse(response.body)
      expect(post["description"]).to eq(example_post.description)
    end

    it "throw error if post not exists" do
      id = 0.to_s

      get "http://localhost:3000/api/posts/" + id
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "update function," do
    let(:headers) { { "Authorization" => "Bearer #{@current_user.jwt}" } }

    let(:patch_full_params) { { post: { image_url: "https://example.com/image-update.jpg", description: "image-update" } } }
    let(:patch_image_params) { { post: { image_url: "https://example.com/image-update.jpg" } } }
    let(:patch_description_params) { { post: { description: "image-update" } } }

    it "update post successfully if post exists" do
      example_post = Post.all.first
      id = example_post.id.to_s

      patch "http://localhost:3000/api/posts/" + id, params: patch_full_params, headers: headers
      expect(response).to have_http_status(:success)

      post = JSON.parse(response.body)
      expect(post["description"]).to eq("image-update")
    end

    it "update post successfully if params not have description" do
      example_post = Post.all.first
      id = example_post.id.to_s

      patch "http://localhost:3000/api/posts/" + id, params: patch_image_params, headers: headers
      expect(response).to have_http_status(:success)

      post = JSON.parse(response.body)
      expect(post["description"]).to eq(example_post.description)
      expect(post["image_url"]).to eq("https://example.com/image-update.jpg")
    end

    it "update post successfully if params not have image_url" do
      example_post = Post.all.first
      id = example_post.id.to_s

      patch "http://localhost:3000/api/posts/" + id, params: patch_description_params, headers: headers
      expect(response).to have_http_status(:success)

      post = JSON.parse(response.body)
      expect(post["description"]).to eq("image-update")
      expect(post["image_url"]).to eq(example_post.image_url)
    end

    it "throw error if post not exists" do
      id = 0.to_s

      patch "http://localhost:3000/api/posts/" + id, params: patch_full_params, headers: headers
      expect(response).to have_http_status(:bad_request)

      post = JSON.parse(response.body)
      expect(post["error"]).to eq("post not found or you are not post owner")
    end

    it "throw error if not post owner" do
      other_user = User.find_by_email("boss2@gmail.com")
      example_post = other_user.posts.first
      id = example_post.id.to_s

      patch "http://localhost:3000/api/posts/" + id, params: patch_full_params, headers: headers
      expect(response).to have_http_status(:bad_request)

      post = JSON.parse(response.body)
      expect(post["error"]).to eq("post not found or you are not post owner")
    end
  end

  describe "destroy function," do
    let(:headers) { { "Authorization" => "Bearer #{@current_user.jwt}" } }

    it "destroy post successfully" do
      example_post = @current_user.posts.first
      id = example_post.id.to_s

      delete "http://localhost:3000/api/posts/" + id, headers: headers
      expect(response).to have_http_status(:success)

      post = JSON.parse(response.body)
      expect(post["message"]).to eq("delete successfully")
    end

    it "throw error if post not exists" do
      id = 0.to_s

      delete "http://localhost:3000/api/posts/" + id, headers: headers
      expect(response).to have_http_status(:bad_request)

      post = JSON.parse(response.body)
      expect(post["error"]).to eq("post not found or you are not post owner")
    end

    it "throw error if not post owner" do
      other_user = User.find_by_email("boss2@gmail.com")
      example_post = other_user.posts.first
      id = example_post.id.to_s

      delete "http://localhost:3000/api/posts/" + id, headers: headers
      expect(response).to have_http_status(:bad_request)

      post = JSON.parse(response.body)
      expect(post["error"]).to eq("post not found or you are not post owner")
    end
  end
end
