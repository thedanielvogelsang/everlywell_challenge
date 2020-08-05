class ExpertiseService
  WEBDRIVER_HEADERS = %w(
    --no-sandbox
    --headless
    --ignore-certificate-errors
    --disable-notifications
    --window-size=1200,600
    --disable-dev-shm-usage
  )

  attr_accessor :browser, :url, :user

  def initialize(url:, user:)
    @url = url
    @user = user
    begin
      options = Selenium::WebDriver::Chrome::Options.new(args: WEBDRIVER_HEADERS)
      @browser = Selenium::WebDriver.for :chrome, options: options
      browse_to_url
    rescue => e
      Rails.logger.info("Selenium Driver error: #{e}")
    end
  end
end