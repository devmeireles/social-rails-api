class AuthenticationController < ApplicationController
  SECRET_KEY = Rails.application.secret_key_base

  def register
    user = User.new(user_params)
    if user.save
      render json: { token: generate_token(user) }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      render json: { token: generate_token(user) }
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

  def generate_token(user)
    JWT.encode({ user_id: user.id }, SECRET_KEY)
  end
end
