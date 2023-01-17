class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:username])
    return invalid_credentials unless user&.authenticate(params[:password])

    session[:user_id] = user.id
    render json: user, status: :ok
  end

  def destroy
    session.delete :user_id
    head :no_content
  end

  private

  def user_params
    params.permit([:username, :password, :password_digest])
  end

  def invalid_credentials
    render json: { error: 'Invalid login credentials' }, status: :unauthorized
  end
end
