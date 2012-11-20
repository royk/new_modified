class NotificationsController < ApplicationController
	  before_filter :correct_user,  only: [:edit, :update, :destroy]

	def create
	end

	def destroy
	end

	def update
	end
	
	private
		def correct_user
			if !current_user.admin?
				@video = current_user.videos.find_by_id(params[:id])
				redirect_to root_url if @video.nil?
			end
		end
end