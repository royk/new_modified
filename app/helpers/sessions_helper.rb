module SessionsHelper
	def super_admins_email
		["roeiklein@gmail.com"]
	end
	def sign_in(user)
		session[:last_visit] = 1.week.ago	# controls age of activities to see on site.
	    user.last_visit = Time.now
	    user.last_online = Time.now
	    user.save!
	    cookies.permanent[:remember_token] = user.remember_token
	    self.current_user = user
	end

	def last_visit
		if session[:last_visit].nil?
			1.week.ago
		else
			session[:last_visit]
		end
	end

	def correct_user?(user)
		signed_in? && (current_user.admin? || current_user==user)
	end

	def signed_in?
		!current_user.nil?
	end

	def admin?
		signed_in? && current_user.admin?
	end

	def super_admin?
		signed_in? && super_admins_email.include?(current_user.email)
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
	end

	def current_user?(user)
		user==current_user
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

	def site_activities
		Notification.where("public= ? AND created_at > ? ", true, last_visit).limit(20).order('id desc')
	end

  def can_see?(item)
    can_see = true
    if !signed_in? && item.public==false
      can_see = false
    end
  	return can_see
  end

	def store_location
		session[:return_to] = request.referer
	end

	def signed_in_user
	    unless signed_in?
	      store_location
	      redirect_to signin_url, notice: "Please sign in."
	    end
	end
end
