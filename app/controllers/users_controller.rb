class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
  before_filter :prevent_redundant_sign_up_access, :only => [:new, :create]

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def edit
    @title = "Edit user"
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def destroy
    user = User.find(params[:id])
    return redirect_to(users_path, 
        :notice => "Invalid opertaion. Admin user cannot delete himself.") if user == current_user
    user.destroy
    flash[:success] = 'User destroyed'
    redirect_to users_path
  end

  private
    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      return redirect_to(signin_path) unless signed_in?
      redirect_to(root_path) unless current_user.admin?
    end

    def prevent_redundant_sign_up_access
      redirect_to(root_path, :notice => "Signed-in user doesn't need to sign up") if signed_in?
    end
end
