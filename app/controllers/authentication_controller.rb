class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  # POST /auth/signup
  def signup
    user = User.new(username: params[:username], password: params[:password])
    if user.save
      token = jwt_encode(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: {error: 'unauthorized'}, status: :unauthorized
    end
  end

  # POST /auth/login
  def login
    user = User.find_by_username(params[:username])
    if user&.authenticate(params[:password])
      token = jwt_encode(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: {error: 'unauthorized'}, status: :unauthorized
    end
  end

end
