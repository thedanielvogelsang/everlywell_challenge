require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user1) { User.create(name: Faker::Name.name, url: Faker::Internet.domain_name(subdomain: "example")) }
  let(:user2) { User.create(name: Faker::Name.name, url: Faker::Internet.domain_name(subdomain: "example")) }

  describe 'validations' do
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:url) }
    it { expect(subject).to validate_presence_of(:shortened_url) }
  end
end
