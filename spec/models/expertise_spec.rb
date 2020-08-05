require 'rails_helper'

RSpec.describe Expertise, type: :model do
  describe 'validation/creation' do
    let(:subject) { Expertise.create(user: user, website_text: 'Heres a bit of text') }
    let(:user) { User.last }

    before(:all) do
      User.create(name: 'Jake Sully', url: 'wwww.example.com')
    end

    it { expect(subject).to validate_uniqueness_of(:website_text).scoped_to(:user_id) }
    it { expect(subject).to belong_to(:user) }
  end
end
