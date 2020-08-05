require 'rails_helper'

RSpec.describe SearchExpertiseService, type: :service do
   before(:all) do
    website_options = %w(
      www.coloradosolidarity.com
      https://www.theguardian.com/us
      https://www.thorn.org/about-our-fight-against-sexual-exploitation-of-children/
      www.practicalbioethics.org/
    )

    4.times do |i|
      VCR.use_cassette('users_with_expertise/user_creation', record: :new_episodes) do
        user = User.create(name: Faker::Name.name, url: website_options[i])
        UserExpertiseService.new(user).call
      end
    end

    User.first.add_friend(User.second)
    User.second.add_friend(User.last)
  end

  let(:subject) { SearchExpertiseService.new(user, search) }
  let(:search) { Search.create(search_text: search_text) }

  let(:user) { User.first }

  describe 'initialization' do
    let(:search_text) { 'whatever' }

    it 'initializes with user, search, empty non_friends array, and fuzzy-string-match object' do
      expect(subject.user).to eq(user)
      expect(subject.search_text).to eq(search.search_text)
    end
  end
end