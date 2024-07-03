class AuthController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:register, :login]

  def register
    user_params = params.permit(:email, :name, :password)
    user = User.new(user_params)

    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end

  def login
    user_params = params.permit(:email, :password)
    user = User.find_by_email(user_params[:email])

    if user.valid_password?(user_params[:password])
      token = JWT.encode({
        id: user.id,
        exp: 30.days.from_now.to_i
      }, Rails.application.credentials.secret_key_base)

      payload = {
        :token => token,
        :user => user
      }

      render json: payload
    else
      render json: {errors: ['Invalid email/password']}, status: :unauthorized
    end
  end

  def me
    render json: @current_user
  end

end
