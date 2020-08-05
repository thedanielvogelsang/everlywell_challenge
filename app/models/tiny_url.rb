class TinyUrl < ApplicationRecord
  TINY_URL_LENGTH = 8

  validates :original_url, presence: true, format: {
    with: /\A(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/i,
    message: "Invalid url"
  }

  before_create :generate_shortened_url
  before_create :sanitize_url

  scope :with_shortened_url, -> (url) { where(shortened_url: url) }

  def create_tiny_url
    url = 'http://' +half_url_sample + '.' + half_url_sample
  end

  private
  def half_url_sample
    ([*('a'..'z'),*('0'..'9')]).sample(TINY_URL_LENGTH/2).join
  end

  def generate_shortened_url
    url = create_tiny_url
    url_already_present = TinyUrl.with_shortened_url(url).first
    if url_already_present
      generate_shortened_url
    else
      self.shortened_url = url
    end
  end

  def sanitize_url
    sanitized_url = self.original_url.gsub(/(https?:\/\/)|(www\.)/, '')
    self.sanitized_url = "http://#{sanitized_url}"
  end
end
