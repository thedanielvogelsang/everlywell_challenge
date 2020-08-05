class Api::V1::UsersController < Api::ApiController
  def index
    render json: User.all, status: 200
  end

  def show
    render json: User.find(params[:id]), status: 200
  rescue => e
    render json: { errors: e }, status: 404
  end

  def create
    user = User.new(user_params)

    if user.save && UserExpertiseService.new(user).call
      render json: user, status: 200
    else
      render json: { errors: user.errors.full_messages }, status: 400
    end
  end

  private
  def user_params
    params.require(:user).permit(:id, :name, :url)
  end
end
