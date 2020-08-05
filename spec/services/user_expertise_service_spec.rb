require 'rails_helper'

RSpec.describe UserExpertiseService, type: :service do
  let(:subject) { UserExpertiseService.new(user) }
  let(:user) { User.create(name: Faker::Name.name, url: known_website_with_tags) }
  let(:tiny_url_record) { TinyUrl.last }
  let(:known_website_with_tags) { 'https://www.coloradosolidarity.com/' }

  it 'initializes with a user' do
    expect(subject.user).to eq(user)
    expect(subject.sanitized_url).to eq(tiny_url_record.sanitized_url)
  end

  describe 'expertise creation' do
    let(:call) { subject.call }
    it 'assigns Expertise to user' do
      expect(Expertise.count).to eq(0)
      call
      expect(Expertise.count).to_not eq(0)
    end
  end
end