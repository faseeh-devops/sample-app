# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    redirect_to root_url if current_user
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        remember user
        redirect_to user
      else
        message = 'Account not Activated'
        message += 'Check Your Email for the Activation Link!'
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid Email / Password Combination!'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in
    redirect_to root_url
  end
end
