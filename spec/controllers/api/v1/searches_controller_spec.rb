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

  describe "POST /find_expert" do
    before(:all) do
      website_options = %w(
        https://www.theguardian.com/us
        www.coloradosolidarity.com
        https://www.thorn.org/about-our-fight-against-sexual-exploitation-of-children/
        www.practicalbioethics.org/
      )

      User.destroy_all

      4.times do |i|
        VCR.use_cassette('users_with_expertise/user_creation', record: :new_episodes) do
          user = User.create(name: Faker::Name.name, url: website_options[i])
          UserExpertiseService.new(user).call
        end
      end

      User.first.add_friend(User.second)
      User.second.add_friend(User.last)
    end

    let(:search_user) { User.first }
    let(:known_fuzzy_match) { 'Care convo' }
    let(:search_term) { known_fuzzy_match }
    let(:non_friend_expertise) { "CARING CONVERSATIONS®" }

    it "returns expected string and http success" do
      expected_node_path = "#{search_user.name}-->#{User.second.name}-->#{User.last.name}(#{non_friend_expertise})"

      post(:find_expert, params: { user: { id: search_user.id, search: search_term } })
      expect(response).to have_http_status(:success)

      expect(JSON.parse(response.body)).to eq(expected_node_path)
    end
  end
end
