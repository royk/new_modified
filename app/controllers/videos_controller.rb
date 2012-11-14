class VideosController < ApplicationController
	before_filter	:signed_in_user,	only: [:create, :destroy]
	before_filter	:correct_user, only: :destroy

	def create
		@video = current_user.videos.build(params[:video])
		@video.user_id = current_user.id
		if parse_video
			if @video.save
				flash[:success] = "Video created"
			else
				flash[:error] = "Video not saved: Already exists"
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
			vimeoID = @video.uid.scan(/vimeo\.com\/(\d+)$/i)
			youtubeIDLong = @video.uid.scan(/(?:youtube\.com\/watch[^\s]*[\?&]v=)([\w-]+)/i);
			youtubeIdShort = @video.uid.scan(/(?:youtu\.be\/)([\w-]+)/i)
			ret = false
			if vimeoID.any?
				@video.uid = vimeoID[0][0]
				@video.vendor = "vimeo"
				ret = true
			end
			if youtubeIDLong.any?
				@video.uid = youtubeIDLong[0][0]
				@video.vendor = "youtube"
				ret = true
			end
			if youtubeIdShort.any?
				@video.uid = youtubeIdShort[0][0]
				@video.vendor = "youtube"
				ret = true
			end
			return ret
		end
end