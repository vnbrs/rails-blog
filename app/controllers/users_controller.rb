class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update show destroy]
  before_action :require_same_user, only: %i[edit update destroy]
  before_action :require_admin, only: %i[destroy]

  def new
    @user = User.new
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to the Alpha Blog, @#{@user.username}!"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'Your account was successfully updated.'
    else
      render 'edit'
    end
  end

  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def destroy
    @user.destroy
    flash[:danger] = "#{@user.username} and all articles has been deleted."
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    return if current_user.admin?
    if current_user != @user
      flash[:danger] = "You can only edit your own account!"
    end
  end
end
