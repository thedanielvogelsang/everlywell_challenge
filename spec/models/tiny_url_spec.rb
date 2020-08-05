require 'rails_helper'

RSpec.describe TinyUrl, type: :model do
  describe 'constants and validations' do
    it { expect(subject).to validate_presence_of(:original_url) }
    it { expect(subject).to_not validate_presence_of(:shortened_url) }
    it { expect(TinyUrl::TINY_URL_LENGTH).to eq(8) }
  end
end
