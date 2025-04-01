class ApplicationController < ActionController::API
  SECRET_KEY = Rails.application.secret_key_base

  def authenticate_user!
    header = request.headers["Authorization"]
    if header
      token = header.split(" ").last
      decoded = JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")
      @current_user = User.find(decoded[0]["user_id"])
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  rescue JWT::DecodeError
    render json: { error: "Invalid token" }, status: :unauthorized
  end
end
