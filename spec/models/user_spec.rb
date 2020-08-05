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
end
