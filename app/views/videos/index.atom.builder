xml.instruct! :xml, version: "1.0"
xml.feed("xlmns"=>"http://www.w3.org/2005/Atom") do
	xml.title "Modified.in Freestyle Footbag Videos"
	xml.id site_url
	xml.updated @videos[0].created_at
	xml.category(term: :sports)
	xml.author do
		xml.name "Roy Klein"
		xml.uri site_url
		xml.email "roeiklein@gmail.com"
	end
	xml.rights "Copyleft 2012, Nobody"
	for video in @videos 
		xml.entry do
			xml.title video.title
			xml.link video_url(video)
			xml.content video.players_names.join(",")
			xml.updated video.created_at
		end
	end

end