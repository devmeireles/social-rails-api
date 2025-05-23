class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: @current_user
  end

  def update
    if @current_user.update(user_params)
      render json: @current_user
    else
      render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @current_user.destroy
    head :no_content
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
