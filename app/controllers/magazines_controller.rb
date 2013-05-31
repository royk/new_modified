class MagazinesController < AuthenticatedController
	require 'yaml'

	def show
		@magazine = Magazine.where("month = ? AND year = ?", params[:month], params[:year]).first
		@videos = Video.find_all_by_id(YAML.load(@magazine.video_ids))
	end
end