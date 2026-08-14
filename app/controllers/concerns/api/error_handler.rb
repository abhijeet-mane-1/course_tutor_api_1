module Api::ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :render_validation_error
    rescue_from ActionController::ParameterMissing, with: :render_parameter_missing
    rescue_from ActionController::BadRequest, with: :render_bad_request
  end

  private

  def render_validation_error(exception)
    render json: {
      errors: exception.record.errors.full_messages.map do |message|
        {
          status: "422",
          code: "VALIDATION_ERROR",
          title: "Validation Error",
          detail: message
        }
      end
    }, status: :unprocessable_content
  end

  def render_parameter_missing(exception)
    render json: {
      errors: [
        {
          status: "400",
          code: "PARAMETER_MISSING",
          title: "Invalid Request",
          detail: exception.message
        }
      ]
    }, status: :bad_request
  end

  def render_bad_request(exception)
    render json: {
      errors: [
        {
          status: "400",
          code: "BAD_REQUEST",
          title: "Bad Request",
          detail: exception.message
        }
      ]
    }, status: :bad_request
  end
end
