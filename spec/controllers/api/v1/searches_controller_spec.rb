require 'rails_helper'

RSpec.describe Api::V1::SearchesController, type: :controller do

  describe "POST /create" do
    it "returns http success" do
      expect(Search.count).to eq(0)
      post(:create, params: { search: { search_text: "What's going on?" } })
      expect(response).to have_http_status(:success)
      expect(Search.count).to eq(1)
      expect(response.body).to eq(Search.last.to_json)
    end
  end
end
