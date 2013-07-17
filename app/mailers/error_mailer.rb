class ErrorMailer < ActionMailer::Base
	def experror(e)
		@err=e
		mail(to: "roeiklein@gmail.com",
			 from: "footbagfront@gmail.com",
			 subject: "#{e.message}")
	end
end