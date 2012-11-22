class UsersController < ApplicationController
  
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :clear_notifications]
  before_filter :correct_user,  only: [:edit, :update]
  before_filter :admin_user,  only: [:destroy]

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def edit
    @user = User.find(params[:id])
  end

  def clear_notifications
    current_user.notifications.where(read: false).each do |n|
      n.read = true;
      n.save
    end
    render :text => ""
  end

  def update
    success = true
    @user = User.find(params[:id])
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].each do |attr|
        if attr[0]!="pasword" && attr[0]!="password_confirmation"
          success = @user.update_attribute(attr[0], attr[1])
          break if !success
        end
      end
    else
      success = @user.update_attributes(params[:user])
    end
    if success
      flash[:success]= "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if !params[:challenge].nil? && params[:challenge]=="freestyle"
      if verify_recaptcha(model: @user, message: "Wrong reCaptcha words, please try again.") && @user.save
        sign_in @user
        flash[:success] = "Welcome to the New Modified!"
        redirect_to @user
      else
        flash[:error] = "Could not sign up"
        render 'new'
      end
    else
      flash[:error] = "Wrong answer to Challenge Question"
      render 'new'
    end
  end

  private

    def correct_user
      if !current_user.admin?
        @user = User.find(params[:id])
        redirect_to(root_path) unless current_user?(@user)
      end
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
