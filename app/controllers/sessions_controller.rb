class SessionsController < ApplicationController
  def new
    @full_site_layout = true
    @bright_body = true
  end

  def create
    @full_site_layout = true
    @bright_body = true
    if (signed_in?)
      sign_out
    end
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.
      sign_in user

      # when super admin logins and they don't have admin flag, turn it on
      if !user.admin? && super_admins_email.include?(user.email)
        user.toggle!(:admin)
      end
      redirect_back_or root_url
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    @full_site_layout = true
    @bright_body = true
    sign_out
    redirect_to root_url
  end

  def forgot_password
    @bright_body = true
    @full_site_layout = true
    render '/sessions/forgot_password'
  end

  def reset_password
    @full_site_layout = true
    user = User.find_by_email(params[:session][:email].downcase)
    unless user.nil?
      flash[:success] = 'Reset password sent to your email.'
      UserMailer.forgot_pwd_mail(user).deliver
      redirect_to root_url
    else
      flash[:error] = 'No user located for this email'
      redirect_to request.referer
    end

  end
end