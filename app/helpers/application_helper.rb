module ApplicationHelper
	def site_name
		"New Modified"
	end
	
	def full_title(page_title)
		if page_title.empty?
			site_name
		else
			"#{site_name} | #{page_title}"
		end
	end

	def active_if(options)
	  if params.merge(options) == params
	    'nav-active'
	  end
	end

	def notify_activity_on(item, sender, action)
		recepient = item.user
		if sender!=recepient && current_user!=recepient
			notification = recepient.notifications.build(sender_id: sender.id)
			notification.user = recepient;
		else
			notification = item.notifications.build(sender_id: sender.id)
		end
		notification.item = item
		notification.action = action
		notification.public = true
		notification.save
	end
end
