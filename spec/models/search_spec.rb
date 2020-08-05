require 'rails_helper'

RSpec.describe Search, type: :model do
  it { expect(subject).to validate_presence_of(:search_text) }
end
