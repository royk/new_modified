class NotificationsController < AuthenticatedController

	def create
	end

	def destroy
	end

	def update
	end

	def index
		col = site_activities
		render partial: 'shared/front_page_notification_item', collection: col
	end

	def get_latest
		if signed_in? 
			current_user.last_online = Time.now
		end
		render partial: 'shared/header_indicator'
	end
	
	private
		def correct_user
			if !current_user.admin?
				@notifications = current_user.notifications.find_by_id(params[:id])
				redirect_to root_url if @notifications.nil?
			end
		end
end