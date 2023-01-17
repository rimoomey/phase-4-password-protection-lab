class UsersController < ApplicationController
  def create
    user = User.create(user_params)
    return invalid_user_input unless user.valid?

    session[:user_id] = user.id
    render json: user, status: :ok
  end

  def show
    user = User.find_by(id: session[:user_id])
    return render json: user, status: :ok unless user.nil?

    unauthorized_user
  end

  private

  def user_params
    params.permit %i[username password password_confirmation password_digest]
  end

  def invalid_user_input
    render json: { error: 'Invalid choice of either username or password' }, status: :unprocessable_entity
  end

  def unauthorized_user
    render json: { error: 'You do not have permission to view this information' }, status: :unauthorized
  end
end
