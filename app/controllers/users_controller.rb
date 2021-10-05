# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[index edit update destroy following followers]
  before_action :correct_user, only: %i[edit update]
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
    redirect_to root_url if current_user
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless current_user.activated?

  end

  def index
    if current_user.nil?
      redirect_to root_url
    else
      @users = User.where(activated: true).paginate(page: params[:page])
    end

  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please Check Your Email to Activate Your Account!'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def following
    @title = 'Following'
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile Updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User has been Deleted'
    redirect_to users_url
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # def logged_in_user
  #   unless logged_in
  #     store location
  #     flash[:danger] = 'Please Log In First'
  #     redirect_to login_url
  #   end
  # end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
