class User < ApplicationRecord
  before_validation :create_tiny_url, if: -> { !tiny_url }

  validates :name, presence: true
  validates :url, presence: true
  validates :tiny_url, presence: true

  attr_reader :sanitized_url

  def create_tiny_url
    tiny_url = TinyUrl.find_or_create_by(original_url: self.url)
    @sanitized_url = tiny_url.sanitized_url
    self.tiny_url = tiny_url.shortened_url
  end
end
