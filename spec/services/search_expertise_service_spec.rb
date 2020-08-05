require 'rails_helper'

RSpec.describe SearchExpertiseService, type: :service do
   before(:all) do
    website_options = %w(
      www.coloradosolidarity.com
      https://www.theguardian.com/us
      https://www.thorn.org/about-our-fight-against-sexual-exploitation-of-children/
      www.practicalbioethics.org/
    )

    4.times do |i|
      VCR.use_cassette('users_with_expertise/user_creation', record: :new_episodes) do
        user = User.create(name: Faker::Name.name, url: website_options[i])
        UserExpertiseService.new(user).call
      end
    end

    User.first.add_friend(User.second)
    User.second.add_friend(User.last)
  end

  let(:subject) { SearchExpertiseService.new(user: user, search: search) }
  let(:search) { Search.create(search_text: search_text) }

  let!(:user) { User.first }
  let!(:friend_of_user) { user.friends.first }
  let!(:user_expertise) { user.expertise.pluck(:website_text) }
  let!(:friend_expertise) { friend_of_user.expertise.pluck(:website_text) }
  let!(:medical_expert_non_friend) { User.last }
  let!(:medical_expertise) { medical_expert_non_friend.expertise.pluck(:website_text) }

  describe 'initialization' do
    let(:search_text) { 'whatever' }

    it 'initializes with user, search, empty non_friends array, and fuzzy-string-match object' do
      expect(subject.user).to eq(user)
      expect(subject.search_text).to eq(search.search_text)
      expect(subject.matches.empty?).to eq(true)
      expect(subject.matcher.class).to eq(FuzzyStringMatch::JaroWinklerPure)
    end

    describe 'user relationships' do
      it { expect(user.friends.count).to eq(1) }
      it { expect(friend_of_user.friends.count).to eq(2) }
      it { expect(medical_expert_non_friend.friends.count).to eq(1) }
      it { expect(friend_of_user).to eq(User.second) }
      it { expect(friend_of_user.friends.include?(medical_expert_non_friend)).to eq(true) }
    end
  end

  describe 'functionality' do
    let(:medical_expertise_sample) { medical_expertise.sample }
    let(:possible_matches) { subject.text_match_known_expertise }
    let(:find_most_likely_match) { subject.find_most_likely_match }
    let(:best_match) { possible_matches.last }

    describe '#text_match_known_expertise' do
      let(:search_text) { medical_expertise_sample }

      it 'can return a list of possible matches, ranked by their fuzzy match constant' do
        jarow_coeff = best_match[0]
        user_id = best_match[1]
        matched_expertise = best_match[2]
        # matches will be sorted by jarow coeff., and index 1 = user_id; index2 = expertise match
        # [[0.5, 1, 'string1'], [0.6, 1, 'string2'], [0.88, 2, 'string3'], [0.9, 3, 'string4']]
        expect(matched_expertise).to eq(medical_expertise_sample)
        expect(user_id).to eq(medical_expert_non_friend.id)
        expect(jarow_coeff).to eq(1.0)
      end
    end

    describe '#find_most_likely_match' do
    context 'on direct match' do
      let(:search_text) { user_expertise.sample }

      it 'a user cannot match themselves' do
        expect(find_most_likely_match).to eq(false)
      end
    end

    context 'on direct match' do
      let(:search_text) { friend_expertise.sample }

      it 'a user cannot match users who are already friends' do
        expect(find_most_likely_match).to eq(false)
      end
    end

    context 'on indirect matching' do
      let(:known_match) { "CARING CONVERSATIONS" }
      let(:matched_expertise_term) { "CARING CONVERSATIONS®" }
      let(:search_text) { known_match.downcase }
      let(:jarow_distance) { subject.matcher.getDistance(known_match, matched_expertise_term) }
      let(:likely_match) { [jarow_distance, medical_expert_non_friend.id, matched_expertise_term] }

      it 'struggles on distinct case' do
        expect(subject.matcher.getDistance(search_text, known_match) >= 0.5).to eq(false)
      end

      it 'upcases search_term and expertise to improve fuzzy-match' do
        expect(find_most_likely_match).to eq(true)
        expect(best_match).to eq([jarow_distance, medical_expert_non_friend.id, matched_expertise_term])
      end

      context 'with different wording' do
        let(:known_match) { "Care convos" }

        it 'still matches correct user and text as most likely' do
          #this 'known match' is a slight adaptation of the known match above, enough to test
          expect(find_most_likely_match).to eq(true)
          expect(best_match).to eq([0.8119975262832406, medical_expert_non_friend.id, "CARING CONVERSATIONS®"])
        end
      end

      context 'with no perfect match' do
        let(:search_text) { "Caring conversations and covid" }
        let(:known_match) { search_text.upcase }
        let(:less_likely_match) { [0.9201840894148586, medical_expert_non_friend.id, "Caring Conversations COVID-19 Tip Sheet"] }

        it 'will sort matches and choose highest jarow coefficient as most-likely match' do
          expect(find_most_likely_match).to eq(true)
          expect(possible_matches.length > 1).to eq(true)

          expect(possible_matches).to eq([less_likely_match, likely_match])
          expect(best_match).to eq(likely_match)
          expect(possible_matches.map{|match| match[0] }).to eq([less_likely_match[0], likely_match[0]])
        end
      end
    end
  end
  end
end