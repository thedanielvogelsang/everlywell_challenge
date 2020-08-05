class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  rescue => e
    render json: { errors: e }, status: 404
  end
end
