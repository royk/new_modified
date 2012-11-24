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
		recipient = item.user
		if !recipient.nil? && sender!=recipient && current_user!=recipient
			notification = recipient.notifications.build(sender: sender)
			notification.user = recipient
		else
			notification = item.notifications.build(sender: sender)
		end
		notification.item = item
		notification.action = action
		notification.public = true
		notification.save
	end

	def privacy_query(collection)
		if signed_in?
			collection.all
		else
			collection.where(public: true)
		end
	end
end
