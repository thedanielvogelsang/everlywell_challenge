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

  describe 'website scraping' do
    let(:h1_titles) { [] }
    let(:h2_titles) do
      ["An inclusive economy starts with us.", "Coops", "SoLIDARITY", "Economy", "The CSF", "Difference", "Join the CSF Community"]
    end
    let(:h3_titles) { ["Get Investment", "Become a Member", "Start a Conversation"] }

    context 'scraping for' do
      it 'h1 headers return predicted h1 elements' do
        VCR.use_cassette('expertise_service/h1_elements_cosolidarity', record: :new_episodes) do
          @driver.find_h1_elements
          expect(@driver.expertise).to eq(h1_titles)
        end
      end
      it 'h2 headers return predicted h2 elements' do
        VCR.use_cassette('expertise_service/h2_elements_cosolidarity', record: :new_episodes) do
          @driver.find_h2_elements
          expect(@driver.expertise).to eq([h2_titles])
        end
      end
      it 'h3 headers return predicted h3 elements' do
        VCR.use_cassette('expertise_service/h3_elements_cosolidarity', record: :new_episodes) do
          @driver.find_h3_elements
          expect(@driver.expertise).to eq([h3_titles])
        end
      end
      it 'can return all together with single method' do
        VCR.use_cassette('expertise_service/all_elements_cosolidarity', record: :new_episodes) do
          @driver.find_all_title_elements
          expect(@driver.expertise).to match_array([h2_titles, h3_titles])
        end
      end
    end
  end
end