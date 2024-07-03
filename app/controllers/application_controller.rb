class ApplicationController < ActionController::Base
  before_action :check_authenticate
  protect_from_forgery with: :null_session

  rescue_from ActionController::ParameterMissing, with: :render_bad_request
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private
  def check_authenticate
    if request.headers['Authorization'].present?
      begin
        token = request.headers['Authorization'].split(' ').last
        decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
        payload = HashWithIndifferentAccess.new(decoded_token)
        @current_user = User.find(payload[:id])
      rescue => e
        Rails.logger.error("Authentication error: #{e.message}")
        render json: { errors: 'Unauthorized' }, status: :unauthorized
      end
    end
  end

  def render_bad_request(exception)
    render json: { error: exception.message }, status: :bad_request
  end

  def render_unprocessable_entity(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def render_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end
end
