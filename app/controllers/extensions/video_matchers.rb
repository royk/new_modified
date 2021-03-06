module VideoMatchers
	require 'open-uri'
	require 'nokogiri'

	def set_video_url(video, url)
		uid_vendor = get_uid_vendor(url)
		if uid_vendor
			video.url = url
			video.vendor = uid_vendor[:vendor]
			video.uid = uid_vendor[:uid]
		end
	end
	
	def get_uid_vendor(url)
		match_youtube(url) || match_vimeo(url) || match_footbag_org(url) || match_jugglingtv(url)
	end

	def match_youtube(url)
		youtubeIDLong = url.scan(/(?:youtube\.com\/watch[^\s]*[\?&]v=)([\w-]+)/i);
		youtubeIdShort = url.scan(/(?:youtu\.be\/)([\w-]+)/i)
		return {uid: youtubeIDLong[0][0], vendor: "youtube"} if youtubeIDLong.any?
		return {uid: youtubeIdShort[0][0], vendor: "youtube"} if youtubeIdShort.any?
	end

	def match_vimeo(url)
		vimeoID = url.scan(/vimeo\.com\/(\d+)$/i)
		{uid: vimeoID[0][0], vendor: "vimeo"} if vimeoID.any?
	end

	def match_footbag_org(url)
		if url.match(/footbag.org/i)
			footbagorg = embed_scrape(url)
			if footbagorg
				footbagorg = footbagorg.scan(/v.footbag.org\/media\/(\d+)\/(.+)/i)
				{uid: "#{footbagorg[0][0]}/#{footbagorg[0][1]}", vendor: "footbagorg"} if footbagorg.any?
			end
		end
	end

	def match_jugglingtv(url)
		if url.match(/juggling.tv/i)
			page = Nokogiri::HTML(open(url))
			if page
				key = page.to_s.scan(/config\.php\?key=(\w+)/i)
				{uid: key[0][0], vendor: "jugglingtv"} if key.any?
			end
		end
	end
	private
		def embed_scrape(url)
			page = Nokogiri::HTML(open(url))
			embed = page.css("embed")
			if embed.any?
				embed = embed[0]
				return embed.attribute("src").to_s
			end
		end
end