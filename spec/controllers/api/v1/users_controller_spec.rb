require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  context 'with users in DB' do
    before(:all) do
      website_options = %w(
        https://www.theguardian.com/us
        www.coloradosolidarity.com
        https://www.thorn.org/about-our-fight-against-sexual-exploitation-of-children/
        www.practicalbioethics.org/
      )

      4.times do |i|
        User.create(name: Faker::Name.name, url: website_options[i])
      end
    end

    describe "GET /index" do
      let(:call) { get :index }

      before { call }

      it "returns http success" do
        expect(response).to have_http_status(:success)
        expect(response.body).to eq(User.all.to_json)
      end
    end

    describe "GET /show" do
      context 'with user_id' do
        it "returns http success" do
          get(:show, params: { id: User.first.id})
          expect(response).to have_http_status(:success)
        end
      end

      context 'without user_id' do
        it "returns http success" do
          get(:show, params: { id: 50})
          expect(response).to have_http_status(404)
        end
      end
    end
  end

  describe 'POST /create' do
    let(:valid_user_params) { { name: 'Jake Sully', url: 'www.practicalbioethics.org/' } }

    it 'can create a new user' do
      VCR.use_cassette("api/v1/user_creation/example_new_user_with_expertise", record: :new_episodes) do
        post(:create, params: { user: {name: 'Example User', url: "www.example.com" } })
        expect(response).to have_http_status(:success)
      end
    end

    it 'returns success only if user is created AND expertise are generated' do
      VCR.use_cassette("api/v1/user_creation/valid_new_user", record: :new_episodes) do
        post(:create, params: { user: valid_user_params })
        expect(response).to have_http_status(:success)
        user = User.last
        expect(user.name).to eq(valid_user_params[:name])
        expect(user.url).to eq(valid_user_params[:url])
        expect(user.tiny_url).to be_truthy
        expect(user.expertise.count).to_not eq(0)
      end
    end

    it 'returns json error and 400 with bad params' do
      post(:create, params: { user: {name: nil, url: "www.example.com" } })
      expect(JSON.parse(response.body)['errors']).to eq(["Name can't be blank"])
      expect(response).to have_http_status(400)
    end
  end
end
