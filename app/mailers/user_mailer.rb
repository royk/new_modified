class UserMailer < ActionMailer::Base
  include ApplicationHelper

  default from: "roeiklein@gmail.com"

  def welcome_mail(user)
  	@user = user
  	@url = site_url
    @site_name = site_name
  	mail(to: user.email, subject: "Welcome to #{site_name}!")
  end

  def forgot_pwd_mail(user)
  	@user = user
  	@url = "#{site_url}reset/#{@user.create_reset_code}"
    @site_name = site_name
  	mail(to: user.email, subject: "Reset password for #{site_name}")
  end

end
