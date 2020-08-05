class Api::V1::SearchesController < ApplicationController
  def create
    search = Search.new(search_params)
    if search.save
      render json: search, status: 200
    else
      render json: { errors: search.errors.full_messages }, status: 400
    end
  end

  private
  def search_params
    params.require(:search).permit(:id, :search_text)
  end
end
