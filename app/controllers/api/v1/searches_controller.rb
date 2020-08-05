class Api::V1::SearchesController < ApplicationController
  def create
    search = Search.new(search_params)
    if search.save
      render json: search, status: 200
    else
      render json: { errors: search.errors.full_messages }, status: 400
    end
  end

  def find_expert
    if Search.create(search_text: permitted_params[:search]) && user = User.find(permitted_params[:id])
      expert_path = SearchExpertiseService.new(search: Search.last, user: user).report_most_likely_match.to_json
      render json: expert_path, status: 200
    else
      render json: { errors: 'Something went wrong, please try again' }, status: 400
    end
  end

  private
  def search_params
    params.require(:search).permit(:id, :search_text)
  end

  def permitted_params
    params.require(:user).permit(:id, :search)
  end
end
