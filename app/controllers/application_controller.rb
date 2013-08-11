class ApplicationController < ActionController::Base
	rescue_from Exception, :with => :handle_exceptions
	private
	def handle_exceptions(e)
		if Rails.env.production?
			ErrorMailer.experror(e).deliver
			render :template => "error_mailer/500", :status => 500
		else
			raise e
		end
	end
  protect_from_forgery
  include SessionsHelper
  include ApplicationHelper
end
