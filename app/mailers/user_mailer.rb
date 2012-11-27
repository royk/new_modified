class UserMailer < ActionMailer::Base
  default from: "roeiklein@gmail.com"

  def welcome_email(user)
  	@user = user
  	@url = "http://www.modified.in"
  	mail(to: user.email, subject: "Welcome to Modified.IN")
  end
end
