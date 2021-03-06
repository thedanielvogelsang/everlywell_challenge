class UserExpertiseService
  attr_reader :user, :sanitized_url

  def initialize(user)
    @user = user
    @sanitized_url = find_sanitized_url_from_user
  end

  def call
    begin
      find_and_create_expertise
    rescue => e
      Rails.logger.warn(e)
      return false
    end
  end

  def find_and_create_expertise
    e = ExpertiseService.new(url: sanitized_url, user: user)
    e.generate_expertise_from_titles
    e.close_connection
  end

  def find_sanitized_url_from_user
    tiny_url = TinyUrl.find_by(shortened_url: user.tiny_url)
    if tiny_url.present? && tiny_url.sanitized_url?
      return tiny_url.sanitized_url
    elsif tiny_url.exists?
      return tiny_url.original_url
    else
      return user.url
    end
  end
end