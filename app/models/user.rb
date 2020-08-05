class User < ApplicationRecord
  before_validation :create_tiny_url, if: -> { !tiny_url }

  validates :name, presence: true
  validates :url, presence: true
  validates :tiny_url, presence: true

  has_many :friendships
  has_many :friends, through: :friendships

  attr_reader :sanitized_url

  def add_friend(friend)
    Friendship.create(user_id: id, friend_id: friend.id)
    Friendship.create(user_id: friend.id, friend_id: id)
  end

  def create_tiny_url
    tiny_url = TinyUrl.find_or_create_by(original_url: self.url)
    @sanitized_url = tiny_url.sanitized_url
    self.tiny_url = tiny_url.shortened_url
  end

  def is_friend?(friend)
    if friend.class == User
      Friendship.exists?(user_id: id, friend_id: friend.id)
    elsif friend.class == Integer
      Friendship.exists?(user_id: id, friend_id: friend)
    end
  end
end
