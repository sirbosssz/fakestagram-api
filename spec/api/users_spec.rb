require "rails_helper"

RSpec.describe "Auth", type: :request do
  before do
    User.create!([
      { email: 'boss1@gmail.com', password: '12345678', username: 'boss1' },
      { email: 'boss2@gmail.com', password: '12345678', username: 'boss2' }
    ])

    @current_user = User.find_by_email("boss1@gmail.com")
  end

  describe "register" do
    it "create user successfully" do
      post "http://localhost:3000/api/register", params: { email: 'boss3@gmail.com', password: '12345678', username: 'boss3' }
      expect(response).to have_http_status(:success)
    end

    it "throw error if duplicate email" do
      post "http://localhost:3000/api/register", params: { email: 'boss1@gmail.com', password: '12345678', username: 'boss3' }
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "login" do
    it "login successfully" do
      post "http://localhost:3000/api/auth/login", params: { email: 'boss1@gmail.com', password: '12345678' }
      expect(response).to have_http_status(:success)

      res = JSON.parse(response.body)
      expect(res["result"]["username"]).to eq("boss1")
    end

    it "throw error if user not found" do
      post "http://localhost:3000/api/auth/login", params: { email: 'boss5@gmail.com', password: '12345678' }
      expect(response).to have_http_status(:bad_request)
    end

    it "throw error if invalid password" do
      post "http://localhost:3000/api/auth/login", params: { email: 'boss1@gmail.com', password: '---' }
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "logout" do
    it "logout successfully" do
      delete "http://localhost:3000/api/auth/logout", headers: { "Authorization" => "Bearer #{@current_user.jwt}" }
      expect(response).to have_http_status(:success)

      res = JSON.parse(response.body)
      expect(res["message"]).to eq("logged out")
    end

    it "throw error if token invalid" do
      delete "http://localhost:3000/api/auth/logout", headers: { "Authorization" => "" }
      expect(response).to have_http_status(:unauthorized)

      res = JSON.parse(response.body)
      expect(res["message"]).to eq(nil)
    end
  end

  describe "check" do
    it "show message if token valid" do
      get "http://localhost:3000/api/auth/check-token", headers: { "Authorization" => "Bearer #{@current_user.jwt}" }
      expect(response).to have_http_status(:success)

      res = JSON.parse(response.body)
      expect(res["message"]).to eq("token valid")
    end

    it "throw error if token invalid" do
      get "http://localhost:3000/api/auth/check-token", headers: { "Authorization" => "" }
      expect(response).to have_http_status(:unauthorized)

      res = JSON.parse(response.body)
      expect(res["message"]).to eq(nil)
    end
  end
end
