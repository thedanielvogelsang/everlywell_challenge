require 'rails_helper'

RSpec.describe "TinyUrls", type: :request do
  before(:all) do
    TinyUrl.create(original_url: 'https://www.youtube.com/watch?v=eXWrt1ctASs')
  end

  let(:sanitized_url) { tiny_url_record.sanitized_url }
  let(:tiny_url_record) { TinyUrl.last }

  describe "GET /show" do
    it "redirects with success" do
      test_url = tiny_url_record.shortened_url
      get "/tiny_urls/show?shortened_url=#{test_url}"
      expect(response.headers["Location"]).to eq(sanitized_url)
      expect(response).to have_http_status(302)
    end
  end
end
