module UsersHelper
	def gravatar_for(user, options = { size: 50 })
		unless user.nil?
		    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		    size = options[:size]
		    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
		    return image_tag(gravatar_url, alt: user.shown_name, class: "gravatar", width: size, height: size)
		else
			gravatar_url = "https://secure.gravatar.com/avatar/00000000000000000000000000000000?s=#{40}"
		    return image_tag(gravatar_url, alt: "no avatar", class: "gravatar", width: 40, height: 40)
		end		    
  	end

  	def create_blog(user)
		user.build_blog(title: "My new blog")
		user.blog.save
    end

end
