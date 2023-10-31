class ApplicationController < ActionController::API
  rescue_from InvalidCheckerError, with: :handle_error_occurred

  rescue_from ActionController::RoutingError, with: :handle_page_not_found

  rescue_from ::ActiveRecord::RecordNotFound, with: :handle_record_not_found
  rescue_from ::NameError, with: :error_occurred

  protected

  def handle_page_not_found(exception)
    render json: { error: exception.message }.to_json, status: :not_found
  end

  def error_occurred(exception)
    render json: { error: exception.message }.to_json, status: :internal_server_error
  end

  def handle_error_occurred(exception)
    render json: { error: exception.message }.to_json, status: :unprocessable_entity
  end
end
