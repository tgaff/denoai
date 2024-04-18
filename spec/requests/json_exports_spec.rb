require 'rails_helper'

RSpec.describe "JsonExports", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/json_exports/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/json_exports/show"
      expect(response).to have_http_status(:success)
    end
  end

end
