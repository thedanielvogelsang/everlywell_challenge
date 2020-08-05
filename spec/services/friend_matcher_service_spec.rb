require 'rails_helper'

RSpec.describe FriendMatcherService, type: :service do
  before(:all) do
    website_options = %w(
      https://www.theguardian.com/us
      www.coloradosolidarity.com
      https://www.thorn.org/about-our-fight-against-sexual-exploitation-of-children/
      www.practicalbioethics.org/
    )

    User.destroy_all

    4.times do |i|
      user = User.create(name: Faker::Name.name, url: website_options[i])
    end

    User.first.add_friend(User.second)
    User.second.add_friend(User.last)
  end

  let(:subject) { FriendMatcherService.new(search_user: user1, new_friend: user2) }
  let!(:user) { User.first }
  let(:friend_of_user) { user.friends.first }
  let(:medical_expert_non_friend) { User.last }

  describe 'initialization' do
    let(:error) { FriendMatcherService::FriendError.new(user1, user2) }
    let(:call) { subject }

    before :each do
      allow(FriendMatcherService::FriendError).to receive(:new).and_raise(error)
    end

    context 'with two users who ARE friends' do
      let(:user1) { user }
      let(:user2) { friend_of_user }
      it 'cant initialize with two users who are friends' do
        expect{ call }.to raise_error(error)
      end
    end

    context 'with two users who ARE friends' do
      let(:user1) { user }
      let(:user2) { medical_expert_non_friend }
      it 'can initialize with two users who are not friends' do
        expect{ call }.to_not raise_error
      end
    end
  end

  describe 'functionality' do
    let(:user1) { user }
    let(:user2) { medical_expert_non_friend }
    let(:call) { subject.find_friend_path }

    context 'with path between users' do
      it 'uses breadth search to find path between nodes' do
        expect(call).to eq([medical_expert_non_friend.id, friend_of_user.id, user.id])
      end
    end

    context 'without path between users' do
      before do
        Friendship.where("user_id = ? OR friend_id = ?", user.id, friend_of_user.id).destroy_all
      end
      it 'returns false' do
        expect(user.friends.empty?).to eq(true)
        expect(call).to eq(false)
      end
    end
  end
end