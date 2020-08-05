require 'rails_helper'

RSpec.describe ExpertiseService, type: :service do
  before :each do
    VCR.use_cassette('expertise_service/selenium_webdriver_reqs', :record => :new_episodes) do
      user = User.create(name: Faker::Name.name, url: 'https://www.coloradosolidarity.com/')
      @driver = ExpertiseService.new(url: user.url, user: user)
    end
  end

  after :each do
    VCR.use_cassette('expertise_service/close_selenium_webdriver', :record => :new_episodes) do
      @driver.close_connection
    end
  end

  let(:user) { User.last }
  let(:my_url) { 'https://www.coloradosolidarity.com/' }

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

    it 'immediately opens a session to input url' do
      VCR.use_cassette('expertise_service/which_page?', :record => :new_episodes) do
        expect(@driver.current_url?).to eq(my_url)
      end
    end
  end
end