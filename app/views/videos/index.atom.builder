xml.instruct! :xml, version: "1.0"
xml.feed("xmlns"=>"http://www.w3.org/2005/Atom") do
	xml.title "#{site_name} Freestyle Footbag Videos"
	xml.link(href: videos_url(:atom), rel: "self")
	xml.link(href: site_url)
	xml.updated @videos[0].created_at.xmlschema
	xml.category(term: :sports)
	xml.id site_url
	xml.author do
		xml.name "Roy Klein"
		xml.uri site_url
		xml.email "roeiklein@gmail.com"
	end
	xml.rights "Copyleft 2012, Nobody"
	for video in @videos 
		xml.entry do
			xml.title video.title
			xml.link(href: video_url(video))
			xml.content video.players_names.join(",")
			xml.updated video.created_at.xmlschema
			xml.id "tag:footbagfront.com,2012-12-07:videos,?id="+video.id.to_s
		end
	end

end