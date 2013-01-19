class ListenersController < ActionController::Base
	def remove_listener
		split = params[:guid].split("-")
		listener_id = Base64::urlsafe_decode64(split[0]).to_i
		user_id = Base64::urlsafe_decode64(split[1]).to_i
		listener = Listener.find_by_id(listener_id)
		success = true
		unless listener.nil?
			if listener.user_id==user_id
				Listener.delete(listener.id)
				flash[:success] = "You will no longer be notified on this content"
				success = true
			end
		end
		unless success
			flash[:error] = "Could not remove you from notification list. Please check your URL and try again"
		end
		redirect_to root_path
	end
end	