class VideosController < ApplicationController
	before_filter	:signed_in_user,	only: [:create, :destroy]
	before_filter	:correct_user, only: :destroy

	def create
		@video = current_user.videos.build(params[:video])
		@video.user_id = current_user.id
		videoParsed = parse_video
		if (videoParsed.any?)
			@video.type = videoParsed["type"]
			@video.uid = videoParsed["uid"]
			if @video.save
				flash[:success] = "Video created"
			end
		else
			flash[:error] = "Unrecognized Video URL"
		end
		redirect_to root_url
	end

	def destroy
		Video.find(params[:id]).destroy
		redirect_to root_url
	end

	private
		def correct_user
			@video = current_user.videos.find_by_id(params[:id])
			redirect_to root_url if @video.nil?
		end

		def parse_video
			vimeoID = @video.url.scan(/vimeo\.com\/(\d+)$/i)
			youtubeIDLong = @video.url.scan(/(?:youtube\.com\/watch[^\s]*[\?&]v=)([\w-]+)/i);
			youtubeIdShort = @video.url.scan(/(?:youtu\.be\/)([\w-]+)/i)
			ret = {}
			if vimeoID.any?
				ret["uid"] = vimeoID[0][0]
				ret["type"] = "vimeo"
			end
			if youtubeIDLong.any?
				ret["uid"] = youtubeIDLong[0][0]
				ret["type"] = "youtube"
			end
			if youtubeIdShort.any?
				ret["uid"] = youtubeIdShort[0][0]
				ret["type"] = "youtube"
			end
			return ret
		end
end