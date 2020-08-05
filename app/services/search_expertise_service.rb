require 'fuzzystringmatch'

class SearchExpertiseService

  attr_reader :friend_ids, :matcher, :matches, :search_text, :user

  def initialize(user, search)
    @user = user
    @friend_ids = user.friends.pluck(:id)
    @search_text = search.search_text
    @matcher = FuzzyStringMatch::JaroWinkler.create( :pure )
    @matches = []
  end

  def text_match_known_expertise
    all_expertise = Expertise.where.not(user_id: user.id).pluck(:user_id, :website_text)
    likely_matches = all_expertise.select do |possible_match|
      matcher.getDistance(search_text.upcase, possible_match[1].upcase) >= 0.8 && !friend_ids.include?(possible_match[0])
    end

    sorted_matches = likely_matches.map do |match|
      jarrow_coefficient = matcher.getDistance(search_text.upcase, match[1].upcase)
      match.unshift(jarrow_coefficient)
    end.sort

    @matches = sorted_matches.empty? ? false : sorted_matches
  end
end