# README

This application is my submission for the [Everlywell Challenge](https://github.com/EverlyWell/backend-challenge)

Met requirements include:

API for creating users, searches, and friendships

1. Users can befriend (bi-directionally) eachother
2. Users have an #index and #show page from which you can see data about users:
* name
* url
* tiny_url
* website 'expertise' (scraped h1-h3 tags)
* links to friends
* search bar which can find non-friends with fuzzy-matched 'expertise'
3. Users can search for expertise outside their network

Things you may want to cover:

* Ruby version
ruby '2.6.3'
rails '~> 6.0.3', '>= 6.0.3.2'

* System dependencies

[brew](https://brew.sh/)

* How to run the test suite

To run test suite, use the command 'rspec' from within the parent folder.
You should see *** passing tests.

* Deployment instructions

`bundle install`

`brew cask (install | upgrade) chromedriver`

you may need to approve chromedriver if you see the following error:
```
"chromedriver" cannot be opened because the developer cannot be verified
```
..if so, navigate to path where Homebrew has installed the chromedriver cask (i.e. '/user/local/Caskroom/chromedriver')
and try this command: `spctl --add --label 'Approved' chromedriver`

other troubleshooting options: [here](https://stackoverflow.com/questions/60362018/macos-catalinav-10-15-3-error-chromedriver-cannot-be-opened-because-the-de)

clone the repo
cd into repo and run `bundle install`

run the following commands:

`rake db:create`
`rake db:migrate`
`rake db:seed`

then fireup the app with `rails server`

