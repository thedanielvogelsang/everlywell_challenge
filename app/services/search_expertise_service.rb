require 'fuzzystringmatch'

class SearchExpertiseService

  attr_reader :friend_ids, :matcher, :matched_term, :search_text, :user
  attr_accessor :matches, :new_friend

  def initialize(user: , search: )
    @user = user
    @friend_ids = user.friends.pluck(:id)
    @search_text = search.search_text
    @matcher = FuzzyStringMatch::JaroWinkler.create( :pure )
    @matches = []
  end

  def report_most_likely_match
    if find_most_likely_match
      friend_matcher = FriendMatcherService.new(search_user: user, new_friend: new_friend)
      if friend_matcher.find_friend_path
        return format_friend_results(friend_matcher.path)
      else
        return "Match found, but no path between users"
      end
    else
      return "No matched user could be found!"
    end
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

  def find_most_likely_match
    text_match_known_expertise

    if matches
      best_match = matches.last

      unless best_match.present?
        return false
      end

      @matched_term = best_match[2]
      @new_friend = User.find(best_match[1])

      return true
    else
      return false
    end
  end

  private
  def format_friend_results(ids)
    ids.reverse.map{ |u| User.find(u).name }.join('-->') + "(#{matched_term})"
  end
end