module ApplicationHelper
	def site_name
		"Footbag Front"
	end

	def site_url
		"http://footbagfront.com/"
	end

	def site_url_no_slash
		"http://footbagfront.com"
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

	def register_new_user(new_user)
		notification = Notification.new
		notification.item = new_user
		notification.public = true
		notification.save!
	end

	def register_new_content(new_item, parent_item=nil)
		notification = Notification.new
		notification.item = new_item
		unless parent_item.nil?
			notification.action = parent_item
			if !parent_item.user.nil? && parent_item.user!=new_item.user
				notify_user_on_item_activity(new_item, parent_item)
			end
		end
		notification.sender = new_item.user
		notification.public = true
		notification.save
	end

	def notify_user_on_item_activity(new_item, parent_item)
		notification = parent_item.user.notifications.build(sender: new_item.user, item: new_item, action: parent_item)
		notification.user = parent_item.user
		notification.public = false
		notification.read = false
		notification.save!
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

	def publishing_query(collection)
		if signed_in?
			if (current_user.admin? || current_user.author?)
				collection.all
			else
				collection.where(published: true)
			end
		else
			collection.where("public = ? AND published = ?", true, true)
		end
	end

	def first_time_visitor?
		last_visit = cookies[:NM]
		if last_visit.nil?
			create_visit_cookie
		else
			return false
		end
	end

	def create_visit_cookie
		cookies.permanent[:NM] = Time.now
	end

	def seed_main_feed
		feed = Feed.create!(name:"Main Feed", permalink:"main_feed")
	  	(Post.all + Video.where("for_feedback=?", false)).each do |item|
	  		item.feed = feed
	  		item.save!
	  	end
	  	return feed
	end

	def seed_admin_feed
		Feed.create!(name:"Admin Feed", permalink:"admin_feed")
	end

	def check_for_mobile
  		session[:mobile_override] = params[:mobile] if params[:mobile]
  		prepare_for_mobile if mobile_device?
	end

	def mobile_device?
  		if session[:mobile_override]
   			session[:mobile_override] == "1"
  		else
			request.user_agent =~ /Mobile|webOS/
  		end
	end

	def prepare_for_mobile
    	prepend_view_path Rails.root + 'app' + 'views_mobile'
  	end

end
