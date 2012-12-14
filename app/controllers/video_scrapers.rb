module VideoScrapers
	require 'open-uri'
	require 'nokogiri'
	
	def footbagorg_scrape(url)
		page = Nokogiri::HTML(open(url))
		embed = page.css("embed")
		if embed.any?
			embed = embed[0]
			return embed.attribute("src").to_s
		end
	end
end