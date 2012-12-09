module BlogScraping
	require 'open-uri'
	require 'nokogiri'

	def scrape(url, name)
		my_url = url.dup
		@name = name
		@result_posts = []
		@result_post = nil		
		@active_post = nil
		curr_page = 0
		page = Nokogiri::HTML(open(url))
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
			scrape_page(page)		
			curr_page += 20
		end
		return @result_posts
	end

	def scrape_page(page)

		# scrape posts
		posts = page.css("div.post")
		posts.each do |post|
			# get date
			date = Date.parse(post.css(".author")[0].children[3].text)
			content = post.css(".content")[0].text
			# get author
			author = post.css(".author > strong").children[0].text
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