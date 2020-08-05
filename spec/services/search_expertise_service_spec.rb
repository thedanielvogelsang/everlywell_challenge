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

  let!(:user) { User.first }
  let!(:friend_of_user) { user.friends.first }
  let!(:user_expertise) { user.expertise.pluck(:website_text) }
  let!(:friend_expertise) { friend_of_user.expertise.pluck(:website_text) }
  let!(:medical_expert_non_friend) { User.last }
  let!(:medical_expertise) { medical_expert_non_friend.expertise.pluck(:website_text) }

  describe 'initialization' do
    let(:search_text) { 'whatever' }

    it 'initializes with user, search, empty non_friends array, and fuzzy-string-match object' do
      expect(subject.user).to eq(user)
      expect(subject.search_text).to eq(search.search_text)
    end

    describe 'user relationships' do
      it { expect(user.friends.count).to eq(1) }
      it { expect(friend_of_user.friends.count).to eq(2) }
      it { expect(medical_expert_non_friend.friends.count).to eq(1) }
      it { expect(friend_of_user).to eq(User.second) }
      it { expect(friend_of_user.friends.include?(medical_expert_non_friend)).to eq(true) }
    end
  end
end