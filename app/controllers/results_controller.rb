class ResultsController < AuthenticatedController
	include VideoMatchers
	def create
		@result = Result.new
		update_result
	end

	def destroy
		destroy! { request.referer }
	end

	def update
		@result = Result.find(params[:id])
		unless @result.nil?
			update_result
		else
			flash[:error] = "Couldn't update competition result"
			redirect_to request.referer
		end
	end

	private
		def update_result
			i = 0
			@result.users.delete
			until params[("Player_#{i.to_s}").to_sym].nil?
				name = params[("Player_#{i.to_s}").to_sym]
				@user = User.find_by_name(name)
				@result.users << @user
				i += 1
			end
			@result.competition_id = params[:competition_id]
			find_video
			@result.update_attributes(params[:result])
			if @result.save
				flash[:success] = "Added competition result"
			else
				flash[:error] = "Couldn't add competition result"
			end
			redirect_to request.referer
		end
		def find_video
			unless params[:video_url].empty?
				@video = Video.new
				set_video_url(@video, params[:video_url])
				unless @video.uid.nil?
					found_video = Video.find_by_uid(@video.uid)
					if found_video.nil?
						# create new 
						# tag the users as the players of the video
						@result.users.each { |u| @video.add_player(u.name) }
						@video.save
					else
						# use existing
						@video = found_video
					end
					params[:result][:video_id] = @video.id
				end
			end
		end
end