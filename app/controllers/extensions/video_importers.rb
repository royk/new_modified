module VideoImporters
	def import_footbagIsrael(json)
		json.each do |v|
			video = v[1]
			
			if video[:deleted]=="0"
				video_item = Video.find_by_uid(video[:src])
				if video_item.nil?
					video_item = Video.new
				end
				video_item.title = video[:title]
				video_item.vendor = video[:type].downcase
				video_item.uid = video[:src]
				video_item.location = video[:location]
				video_item.created_at = video[:date]
				video_item.updated_at = video[:date]
				video_item.maker = video[:maker]
				video_item.players = []
				_players = video[:players].split(' ')
				video_item.tag_list = []
				if _players.any?
					index = 0
					for player in _players
						video_item.tag_list << player
						if index%2==0
							p = player
							p << " "
						else
							p << player
							video_item.players << p
						end
						index = index + 1
					end
				end
				tags = video[:tags].split(' ')
				video_item.tag_list = video_item.tag_list + tags
				video_item.save
			end
		end
	end
end