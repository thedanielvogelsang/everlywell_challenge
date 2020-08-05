class User < ApplicationRecord
  before_validation :create_tiny_url, if: -> { !tiny_url }

  validates :name, presence: true
  validates :url, presence: true
  validates :tiny_url, presence: true

  def create_tiny_url
    self.tiny_url = url
  end
end
