base_url = site_url[0..-2];
xml.instruct! :xml, version: "1.0"
xml.feed("xmlns"=>"http://www.w3.org/2005/Atom") do
	xml.title "Freestyle Footbag Community Feed: #{@feed.name}"
	xml.link(href: base_url+feed_path(@feed.permalink, :atom), rel: "self")
	xml.link(href: site_url)
	if @feed_items.any?
		xml.updated @feed_items[0].created_at.xmlschema
	else
		xml.updated @feed.created_at.xmlschema
	end
	xml.category(term: :sports)
	xml.id site_url
	xml.author do
		xml.name @feed.user.name unless @feed.user.nil?
		xml.uri site_url
		xml.email @feed.user.email unless @feed.user.nil?
	end
	xml.rights "Copyleft 2012, Nobody"
	for item in @feed_items 
		xml.entry do

			if item.respond_to?(:content)
				xml.title Sanitize.clean(item.content[0,30])+"..."
				xml.link(href: base_url+polymorphic_path(item))
				xml.content item.content
			elsif item.class.to_s.downcase=="video"
				xml.title Sanitize.clean(item.title)
				xml.link(href: video_url(item))
				xml.content item.players_names.join(",")
			end
				
			xml.updated item.updated_at.xmlschema
			xml.id "tag:footbagfront.com,2012-12-07:feed,?id="+@feed.id.to_s
		end
	end

end