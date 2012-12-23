class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :destroy]
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
    unless current_user.nil?
      current_user.notifications.where(read: false).each do |n|
        n.read = true;
        n.save
      end
    end
    render :text => ""
  end

  def reset_password
    @user = User.find_by_reset_code(params[:reset_code]) unless params[:reset_code].nil?
    if @user
      @user.reset_code = nil
      @user.save
      sign_in @user
      redirect_to edit_user_path(@user)

    else
      redirect_to root_path
    end
  end


  def update
    @user = User.find(params[:id])
    unless @user.nil?
      update_user_admin unless params[:admin].nil?
      update_user_author unless params[:author].nil?
      update_user_normal unless params[:user].nil?
    else
      redirect_to request.referer
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = privacy_query(@user.posts).paginate(page: params[:page])
    @videos = privacy_query(@user.appears_in_videos).paginate(page: params[:page])
    @articles = publishing_query(@user.articles).paginate(page: params[:page], :per_page => 10)
    unless @user.blog.nil?
      @blog_posts = privacy_query(@user.blog.blog_posts).paginate(page: params[:page]) 
    else
      @blog_posts = []
    end
    render layout: "no_activities"
  end

  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    return unless anti_spam_verifications
    if @user.save
      Video.move_to_user_players(@user)
      UserMailer.welcome_mail(@user).deliver
      sign_in @user
      flash[:success] = "Welcome to the New Modified!"
      notify_activity_on(@user, current_user)
      redirect_to "/static/welcome"
    else
      flash[:error] = "Could not sign up"
      render 'new'
    end
  end

  private

    def update_user_admin
      @user.update_attribute(:admin, params[:admin]) if current_user.admin?
      redirect_to request.referer
    end

    def update_user_author
      @user.update_attribute(:author, params[:author]) if current_user.admin?
      redirect_to request.referer
    end

    def update_user_normal
      params[:user].delete(:password) if params[:user][:password].blank?
      params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank?
      if @user.update_attributes(params[:user])
        flash[:success]= "Profile updated"
        sign_in @user
        redirect_to @user
      else
        render 'edit'
      end
    end

    def anti_spam_verifications
      if params[:challenge].nil? || params[:challenge].match(/^free\s?style.*/i).nil?
        flash[:error] = "Wrong answer to Challenge Question"
        render 'new'
        return false
      end
      return true
      # if verify_recaptcha(model: @user, message: "Wrong reCaptcha words, please try again.") && @user.save
    end

    def correct_user
      if !current_user.nil? && !current_user.admin?
        @user = User.find(params[:id])
        redirect_to(root_path) unless current_user?(@user)
      end
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
