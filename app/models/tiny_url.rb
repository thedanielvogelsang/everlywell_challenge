class TinyUrl < ApplicationRecord
  TINY_URL_LENGTH = 8

  validates :original_url, presence: true, format: {
    with: /\A(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/i,
    message: "Invalid url"
  }

  before_create :generate_shortened_url

  def generate_shortened_url
    url = self.original_url
    self.shortened_url = url
  end

end
