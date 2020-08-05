require 'rails_helper'

RSpec.describe Friendship, type: :model do
  describe 'validation/creation' do
    it { expect(subject).to validate_presence_of(:user_id) }
    it { expect(subject).to validate_presence_of(:friend_id) }
  end
end
