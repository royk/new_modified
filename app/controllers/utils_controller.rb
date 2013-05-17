class UtilsController  < ApplicationController
	before_filter :admin_user

	def newsletter

		UserMailer.footbag_magazine_mail(Date.today - 30, current_user).deliver

	end
	private
		def admin_user
			if current_user.nil?
				redirect_to root_path
				return
			end
			redirect_to(root_path) unless current_user.admin?
		end
end