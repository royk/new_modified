class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    
    if (!signed_in?)
      if user && user.authenticate(params[:session][:password])
        # Sign the user in and redirect to the user's show page.
        sign_in user

        # when super admin logins and they don't have admin flag, turn it on
        if !user.admin? && super_admins_email.include?(user.email)
          user.toggle!(:admin)
        end
        redirect_back_or user
      else
        flash.now[:error] = 'Invalid email/password combination' # Not quite right!
        render 'new'
      end
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end