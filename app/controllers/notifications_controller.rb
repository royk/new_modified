class NotificationsController < AuthenticatedController

	def create
	end

	def destroy
	end

	def update
	end

	def index
		render partial: 'shared/front_page_notification_item', collection: Notification.find(:all, order: "id desc", limit: 20)
	end

	def get_latest
		render partial: 'shared/notifications/header_indicator'
	end
	
	private
		def correct_user
			if !current_user.admin?
				@notifications = current_user.notifications.find_by_id(params[:id])
				redirect_to root_url if @notifications.nil?
			end
		end
end