require 'rails_helper'

RSpec.describe "Freights", type: :request do
  describe "GET /calculate" do
    it "returns http success" do
      get "/freights/calculate"
      expect(response).to have_http_status(:success)
    end
  end

end
