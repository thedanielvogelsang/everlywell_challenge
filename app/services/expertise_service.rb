class ExpertiseService
  WEBDRIVER_HEADERS = %w(
    --no-sandbox
    --headless
    --ignore-certificate-errors
    --disable-notifications
    --window-size=1200,600
    --disable-dev-shm-usage
  )

  attr_accessor :browser, :expertise, :url, :user

  def initialize(url:, user:)
    @url = url
    @user = user
    @expertise = []
    begin
      options = Selenium::WebDriver::Chrome::Options.new(args: WEBDRIVER_HEADERS)
      @browser = Selenium::WebDriver.for :chrome, options: options
      browse_to_url
    rescue => e
      Rails.logger.info("Selenium Driver error: #{e}")
    end
  end

  def browse_to_url
    browser.navigate.to(url)
  end

  def close_connection
    @browser.close
  end

  def current_url?
    browser.current_url
  end

  def find_all_title_elements
    find_h1_elements
    find_h2_elements
    find_h3_elements
  end

  def find_h1_elements
    elems = browser.find_elements(:tag_name, 'h1')
    unless elems.empty?
      expertise << elems.map{ |el| el.text }
    end
  end

  def find_h2_elements
    elems = browser.find_elements(:tag_name, 'h2')
    unless elems.empty?
      expertise << elems.map{ |el| el.text }
    end
  end

  def find_h3_elements
    elems = browser.find_elements(:tag_name, 'h3')
    unless elems.empty?
      expertise << elems.map{ |el| el.text }
    end
  end
end