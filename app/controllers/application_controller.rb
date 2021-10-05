class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  def handle_not_found
    flash[:danger] = 'Record Not Found!'
    redirect_to(request.referer || root_path)
  end

end
