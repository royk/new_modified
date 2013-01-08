class ResultsController < AuthenticatedController
	include VideoMatchers
	def create
		update_result
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
			find_video
			@user = User.find_by_name(params[:user_name])
			unless @user.nil?
				unless @result.nil?
					if @result.user!=@user
						@result = nil
					end
				end
				@result = Result.create(user: @user, competition_id: params[:competition_id]) if @result.nil?
				@result.update_attributes(params[:result])
				if @result.save
					flash[:success] = "Added competition result"
				else
					flash[:error] = "Couldn't add competition result"
				end
			end
			redirect_to request.referer
		end
		def find_video
			unless params[:video_url].empty?
				uid_vendor = get_uid_vendor(params[:video_url])
				unless uid_vendor.nil?
					video = Video.find_by_uid(uid_vendor[:uid])
					if video.nil?
						#create video
					else
						params[:result][:video_id] = video.id
					end
				end
			end
		end
end