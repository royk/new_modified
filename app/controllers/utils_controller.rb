class UtilsController  < ApplicationController
	before_filter :admin_user

	def generateNewsletter
		magazine = Magazine.new
		magazine.name = "May"
		magazine.start_date = DateTime.parse("2013-05-01")
		magazine.end_date = DateTime.parse("2013-05-31")
		videos = Video.all(select: :id, conditions: ["date(created_at) BETWEEN ? AND ? ", '2013-05-01', '2013-05-31']).collect(&:id)
		magazine.video_ids = videos
		magazine.save!
		redirect_to root_path

	end
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