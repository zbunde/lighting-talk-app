class Admin::UsersController < ApplicationController
  before_action :set_user, only:[:show, :edit, :update]
  before_action :require_admin

  def index
    @users = User.order(:username).page params[:page]
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    user.auth_token = "pending"
    if user.save
      flash[:notice] = "You have successfully added a new user"
      redirect_to admin_users_path
    else
      @user = user
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "You have successfully updated a user"
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    flash[:notice] = "You have removed a user"
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :admin)
  end

  def set_user
    @user = User.find(params[:id])
  end

end
