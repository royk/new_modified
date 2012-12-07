module ApplicationHelper
	def site_name
		"New Modified"
	end

	def site_url
		"http://modified.poisontaffy.com/"
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

	def notify_activity_on(item, sender, action=nil)
		# refactor this
		# the idea is: if the notificiation is on reaction (comment, like), don't notify if the sender is also the receiver.
		if !action.nil?
			recipient = item.user
			if (sender==recipient || current_user==recipient)
				return
			end
		end

		if !recipient.nil?
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

	def notify_tag(item, tagger, taggee)
		logger.debug "Notify Tag"
		if tagger!=taggee
			notification = taggee.notifications.build(sender: tagger)
			notification.user = taggee
			notification.item = item
			notification.action_type = "tag"
			notification.public = false;
			notification.save
			logger.debug "SAVING" + notification.inspect
		end
	end

	def privacy_query(collection)
		if signed_in?
			collection.all
		else
			collection.where(public: true)
		end
	end

end
