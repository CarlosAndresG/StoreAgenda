class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found
    render status: :not_found, json: {
      message: 'Record invalid or not found',
      data: nil
    }
  end
end
