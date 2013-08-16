class ErrorMailer < ActionMailer::Base
	def experror(e)
		@err=e
		mail(to: "footbagfront@gmail.com",
			 from: "footbagfront@gmail.com",
			 subject: "#{e.message}")
	end
end