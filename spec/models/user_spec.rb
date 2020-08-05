require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user1) { User.create(name: Faker::Name.name, url: Faker::Internet.domain_name(subdomain: "example")) }
  let(:user2) { User.create(name: Faker::Name.name, url: Faker::Internet.domain_name(subdomain: "example")) }

  describe 'validations' do
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:url) }
    it { expect(subject).to validate_presence_of(:tiny_url) }
  end

  describe 'creation' do
    before(:each) do
      TinyUrl.destroy_all
    end

    let(:user) { User.new(name: Faker::Name.name, url: Faker::Internet.domain_name(subdomain: "example")) }

    it 'can create a user with name and url' do
      user.save
      expect(user.errors.empty?).to eq(true)
    end

    it 'exposes sanitized_url upon creation' do
      expect(user.sanitized_url).to eq(nil)
      expect(user).to respond_to(:sanitized_url)
      user.save
      expect(user.sanitized_url).to be_truthy
    end

    it 'generates a shortened url automatically for user' do
      expect(user.tiny_url.blank?).to eq(true)
      expect(TinyUrl.count).to eq(0)
      user.save
      expect(user.tiny_url.blank?).to eq(false)
      expect(TinyUrl.count).to eq(1)
    end
  end

  describe 'expertise' do
    before(:each) do
      Expertise.destroy_all
    end

    let(:user) { User.create(name: Faker::Name.name, url: known_website_with_tags) }
    let(:known_website_with_tags) { 'https://www.coloradosolidarity.com/' }

    it 'finds and saves Expertise when passed to UserExpertiseService' do
      VCR.use_cassette('user_creation/all_elements_cosolidarity', record: :new_episodes) do
        expect(Expertise.count).to eq(0)
        expect(user.expertise.count).to eq(0)
        UserExpertiseService.new(user).call

        expect(Expertise.count).to_not eq(0)
        expect(user.expertise.count).to_not eq(0)
      end
    end
  end

  describe 'friendships' do
    let(:friendship) { Friendship.create(user_id: user1.id, friend_id: user2.id) }

    it 'can be created' do
      expect(friendship.errors.empty?).to eq(true)
    end

    describe 'bi-directionality' do
      before :each do
        user1.add_friend(user2)
      end

      it 'can call friendships bi-directionally' do
        expect(user1.friends.first).to eq(user2)
        expect(user2.friends.first).to eq(user1)
      end
    end
  end

  describe 'utility' do
    before(:each) do
      user1.add_friend(user2)
    end

    it 'can check for friendship using #is_friend?' do
      expect(user1.is_friend?(user2)).to eq(true)
    end
  end
end
