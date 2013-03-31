module UsersHelper
	def gravatar_for(user, options = { size: 50 })
		unless user.nil?
		    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		    size = options[:size]
		    gravatar_url = "http://en.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=404"
		    url = URI.parse(gravatar_url)
		    res = Net::HTTP.get(url)
		    if res=="404 Not Found"
		    	gravatar_url = "https://secure.gravatar.com/avatar/2cc2c37963368cc3c03580a665aae8a7?s=#{40}"
		    end
		    return image_tag(gravatar_url, alt: user.shown_name, class: "gravatar", width: size, height: size)
		else
			gravatar_url = "https://secure.gravatar.com/avatar/2cc2c37963368cc3c03580a665aae8a7?s=#{40}"
		    return image_tag(gravatar_url, alt: "no avatar", class: "gravatar", width: 40, height: 40)
		end		    
  	end

  	def create_blog(user)
		user.build_blog(title: "My new blog")
		user.blog.save
	end

	def real_name(user)
		if signed_in?
			user.name
		else
			user.shown_name
		end
	end

end
