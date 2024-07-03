class AuthController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:register, :login]

  def register
    user_params = params.permit(:email, :name, :password)
    user = User.new(user_params)

    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user_params = params.permit(:email, :password)
    user = User.find_by_email(user_params[:email])

    if user.valid_password?(user_params[:password])
      render plain: 'Authenticated!'
    else
      render plain: 'Error!!'
    end
  end

  def me
    render plain: 'auth#me'
  end

end
