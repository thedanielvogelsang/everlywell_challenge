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
  end
end
