class VideosController < ApplicationController
	before_filter	:signed_in_user,	only: [:create, :destroy]
	before_filter	:correct_user, only: :destroy

	def create
		@video = current_user.videos.build(params[:video])
		@video.user_id = current_user.id
		if @video.save
			flash[:success] = "Video created"
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
end