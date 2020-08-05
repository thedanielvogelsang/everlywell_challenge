# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

website_options = %w(
  www.coloradosolidarity.com
  https://www.theguardian.com/us
  https://www.thorn.org/about-our-fight-against-sexual-exploitation-of-children/
  www.practicalbioethics.org/
  https://en.wikipedia.org/wiki/Investment_banking
  https://en.wikipedia.org/wiki/Breadth-first_search
)

6.times do |i|
  user = User.create(name: Faker::Name.name, url: website_options[i])
  UserExpertiseService.new(user).call
end

user = User.first
friend = User.second
friends_friend_none = User.third
friends_friend_with_friend = User.fourth
third_gen_friend = User.fifth
last_gen_friend = User.last

user.add_friend(friend)

friend.add_friend(friends_friend_none)
friend.add_friend(friends_friend_with_friend)

friends_friend_with_friend.add_friend(third_gen_friend)
third_gen_friend.add_friend(last_gen_friend)

# Best search to issue is a direct match for User.last (last_gen_friend): '"Breadth-first search"'
# This should create a path way from User.first to User.last