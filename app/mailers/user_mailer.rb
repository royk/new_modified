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

  def listener_mail(listener)
    @user = listener.user
    @url = "#{site_url_no_slash}#{polymorphic_path listener.listened_to}"
    @site_name = site_name
    to_destroy_guid = "#{Base64::urlsafe_encode64(listener.id.to_s)}-#{Base64::urlsafe_encode64(@user.id.to_s)}"
    @stop_url = "#{site_url_no_slash}/stop_listening/#{to_destroy_guid}"
    mail(to: @user.email, subject: "Someone responded on your #{listener.listened_to.class.to_s}")
  end


end
