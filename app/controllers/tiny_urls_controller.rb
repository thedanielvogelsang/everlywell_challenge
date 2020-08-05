class TinyUrlsController < ApplicationController
  before_action :find_url

  def show
    redirect_to @url.sanitized_url
  end

  private

  def find_url
    @url = TinyUrl.find_by_shortened_url(params[:shortened_url])
  end
end
