require 'fuzzystringmatch'

class SearchExpertiseService

  attr_reader :search_text, :user

  def initialize(user, search)
    @user = user
    @search_text = search.search_text
  end
end