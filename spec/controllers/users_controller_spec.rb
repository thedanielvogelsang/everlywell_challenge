require 'rails_helper'

RSpec.describe UsersController, type: :controller do
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
