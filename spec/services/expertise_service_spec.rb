require 'rails_helper'

RSpec.describe ExpertiseService, type: :service do
  before :each do
    user = User.create(name: Faker::Name.name, url: 'http://coloradosolidarity.com')
    @driver = ExpertiseService.new(url: user.url, user: user)
  end


  let(:user) { User.last }
  let(:my_url) { 'http://coloradosolidarity.com' }

  describe '#initialize' do
    let(:headers) { %w(
      --no-sandbox
      --headless
      --ignore-certificate-errors
      --disable-notifications
      --window-size=1200,600
      --disable-dev-shm-usage
    )}

    it 'initializes with proper Selenium::WebDriver headers and setup' do
      expect(ExpertiseService::WEBDRIVER_HEADERS).to eq(headers)
      expect(@driver.browser.class).to eq(Selenium::WebDriver::Chrome::Driver)
    end

    it 'initializes with a user' do
      expect(@driver.user).to eq(user)
      expect(@driver.url).to eq(my_url)
    end
  end
end