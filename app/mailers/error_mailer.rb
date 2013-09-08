class ErrorMailer < ActionMailer::Base
	def experror(e, request)
		@err=e
		@request = request
		mail(to: "footbagfront@gmail.com",
			 from: "footbagfront@gmail.com",
			 subject: "#{e.message}")
	end
end