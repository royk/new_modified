module BlogScraping
	require 'open-uri'
	require 'nokogiri'

	def scrape_blogspot(feed_url)
		# remove any params from url
		my_url = feed_url.dup.gsub(/\?.*/, "")
		page = Nokogiri::XML open my_url
		page.remove_namespaces!
		# find out total posts count
		posts_count = page.xpath("//totalResults").text.to_i
		# re-request feed with all posts in it
		my_url = "#{my_url}?start-index=1&max-results=#{posts_count}"
		page = Nokogiri::XML open my_url
		page.remove_namespaces!
		posts = page.xpath("//entry")
		@result_posts = []
		posts.each do |post|
			date = Time.parse(post.xpath("published").text)
			content = post.xpath("content").text
			title = post.xpath("title").text

			@result_post = {}
			@result_post[:comments] = []
			@result_post[:date] = date
			@result_post[:content] = content
			@result_post[:author] = current_user.name
			@result_post[:title] = title
			@result_posts << @result_post
		end
		return @result_posts
	end


	def scrape_modified(url, name)
		# remove any page indication from url
		my_url = url.dup.gsub(/&start=\d*/, "")
		@name = name
		@result_posts = []
		@result_post = nil		
		@active_post = nil
		@validated = false
		curr_page = 0

		page = Nokogiri::HTML(open(my_url))
		# collect all pages needed to be scraped
		pages = page.css("div.pagination").css("a")
		pages = pages[pages.count-1]	# last link contains the last blog page
		url = pages["href"]
		last_page = url.match(/start=(\d+)/)[1].to_i
		
		until curr_page>last_page
			if curr_page>0
				new_url = "#{my_url}&start=#{curr_page.to_s}"
				page = Nokogiri::HTML(open(new_url))
			end
			scrape_modified_page(page, curr_page)
			return nil unless @validated
			curr_page += 20
		end
		return @result_posts
	end

	def scrape_modified_page(page, index)

		# scrape posts
		posts = page.css("div.post")
		posts.each_with_index do |post, i|

			# get date
			date = Time.parse(post.css(".author")[0].children[3].text)
			# get content
			content = post.css(".content")[0].inner_html
			content = content.gsub(/\.\/images\/smilies\//i, "/assets/smilies/") # reroute smilies url to our own
			# get author
			author = post.css(".author > strong").children[0].text
			# When reading the first post of the blog, make sure it is posted by the user requesting the import. Otherwise, abort.
			if index==0 && i==0
				if author==@name
					@validated = true
				else
					return false
				end
			end
			@result_post = {}
			@result_post[:date] = date
			@result_post[:content] = content
			@result_post[:author] = author
			@result_post[:comments] = []
			if author==@name
				@result_posts << @result_post
				@active_post = @result_post
			else
				@active_post[:comments] << @result_post unless @active_post.nil?
			end
		end
	end
end