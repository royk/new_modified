class UserMailer < ActionMailer::Base
  default from: "roeiklein@gmail.com"

  def welcome_mail(user)
  	@user = user
  	@url = "http://www.modified.in"
  	mail(to: user.email, subject: "Welcome to Modified.IN")
  end

  def forgot_pwd_mail(user)
  	@user = user
  	@url = "http://www.modified.in/reset/#{@user.create_reset_code}"
  	mail(to: user.email, subject: "Reset password for Modified.IN")
  end

end
