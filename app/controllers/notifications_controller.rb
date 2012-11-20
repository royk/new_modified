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
				@notifications = current_user.notifications.find_by_id(params[:id])
				redirect_to root_url if @notifications.nil?
			end
		end
end