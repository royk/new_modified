class UsersController < ApplicationController
	include ApplicationHelper

	before_filter :signed_in_user, only: [:edit, :update, :destroy]
	before_filter :correct_user,  only: [:sessions_timeline, :edit, :update]
	before_filter :admin_user,  only: [:destroy]

	def export
		unless signed_in?
			redirect_to root_path
		end
		send_data(current_user.export_to_csv, filename: "#{current_user.name}_data.csv", type: "application/x-yaml")
	end

	def user_enable_chat
		if signed_in?
			enable_chat
		end
		who_online
	end

	def who_online
		if signed_in? && chat_enabled?
			current_user.last_online =  Time.now
			current_user.save_without_signout
		end
		@online_users = User.where("last_online > ?", 5.minutes.ago)
		render partial: 'shared/users/who_online'
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User deleted."
		redirect_to request.referer
	end

	def index
		params[:sort_method] = "all"
		sorted_index
	end

	def timeline
		@user = User.find(params[:id])
		@full_site_layout = true
		@bright_body = true
		@custom_container_style = "width:100%;"
		@custom_body_style = "background-color:white;"
		@custom_bg2_style = "display:none;"
	end

	def sessions_timeline
		@user = User.find(params[:id])
		@sessions = nil
		if @user
			need_to_check_public = @user!=current_user
			@full_site_layout = true
			@bright_body = true
			@custom_container_style = "width:100%;"
			@custom_body_style = "background-color:white;"
			@custom_bg2_style = "display:none;"
			if need_to_check_public
				@sessions = TrainingSession.where("user_id=? and public=? and ((startTime IS NULL) OR (startTime IS NOT NULL AND endTime IS NOT NULL))", @user.id, true)
			else
				@sessions = TrainingSession.where("user_id=? and ((startTime IS NULL) OR (startTime IS NOT NULL AND endTime IS NOT NULL))", @user.id)
			end
		end
	end

	def sorted_index
		if params[:sort_method].to_s.strip.length == 0
			params[:sort_method] = "all"
		end
		case(params[:sort_method].downcase)
			when "all"
				@users = User.where(registered: true)
			when "latest"
				@users = User.where(registered: true).order('id desc')
			when "nearby"
				if signed_in?
					if current_user.geocoded?
						@users = current_user.nearbys(9999).where(registered: true).order("distance")
					else
						@users = User.where(registered: true)
					end
				end
		end
		if request.xhr?
			render partial: '/users/user', collection: @users
		else
			render action: :index
		end
	end

	def edit
		@full_site_layout = true
		@bright_body = true
		@user = User.find(params[:id])
	end

	def clear_notifications
		unless current_user.nil?
			notifications = current_user.notifications.where(read: false)
			if notifications.any?
				notifications.each do |n|
					n.read = true
					n.save!
				end
			end
		end
		render :text => ""
	end

	def reset_password
		@full_site_layout = true
		@bright_body = true
		@user = User.find_by_reset_code(params[:reset_code]) unless params[:reset_code].nil?
		if @user
			@user.reset_code = nil
			sign_in @user
			@user.save_without_signout

			redirect_to edit_user_path(@user)

		else
			redirect_to root_path
		end
	end


	def update
		@full_site_layout = true
		@bright_body = true
		@user = User.find(params[:id])
		unless @user.nil?
			update_user_admin unless params[:admin].nil?
			update_user_author unless params[:author].nil?
			update_user_normal unless params[:user].nil?
		else
			redirect_to request.referer
		end
	end

	def show
		begin
			@user = User.find(params[:id])
		rescue
			redirect_to(root_path)
			return;
		end
		@posts = privacy_query(@user.posts).paginate(page: params[:page], per_page: 10)
		@videos = privacy_query(@user.appears_in_videos).paginate(page: params[:page], per_page: 10)
		@articles = publishing_query(@user.articles).paginate(page: params[:page], :per_page => 10)
		unless @user.blog.nil?
			@blog_posts = privacy_query(@user.blog.blog_posts).paginate(page: params[:page], per_page: 10)
			@blog_id = @user.blog.id
		else
			@blog_posts = []
		end
		@competition_entries = get_sorted_competition_entries
		@event_ids = @competition_entries.map {|a| a[:event].id }
		render layout: "no_activities"
	end

	def user_videos
		@user = User.find(params[:id])
		@videos = privacy_query(@user.appears_in_videos).paginate(page: params[:page], per_page: 10)
		render partial: 'shared/feed_item', collection: @videos, comments_shown: false
	end

	def user_posts
		@user = User.find(params[:id])
		@posts = privacy_query(@user.posts).paginate(page: params[:page], per_page: 10)
		render partial: 'shared/feed_item', collection: @posts, comments_shown: false
	end

	def user_articles
		@user = User.find(params[:id])
		@articles = privacy_query(@user.articles).paginate(page: params[:page], per_page: 10)
		render partial: 'shared/feed_item', collection: @articles, comments_shown: false
	end

	def new
		@full_site_layout = true
		@bright_body = true
		@user = User.new
	end

	def create
		@full_site_layout = true
		@bright_body = true
		return unless anti_spam_verifications
		@user = migrate_virtual_profile
		@user = User.new(params[:user]) if @user.nil?
		if @user.save_without_signout
			Video.move_to_user_players(@user)
			unless params[:admin_created]
				UserMailer.welcome_mail(@user).deliver
				sign_in @user
				flash[:success] = "Welcome to #{site_name}! We recommend filling in some details in your user profile."
				register_new_user(@user) if @user.registered
				redirect_to root_path
			else
				redirect_to request.referer
			end
		else
			flash[:error] = "Could not sign up"
			render 'new'
		end
	end

	private

	def migrate_virtual_profile
		virtual_profile = User.where("name LIKE ? AND registered = ?", params[:user][:name], false).first
		unless virtual_profile.nil?
			virtual_profile.registered = true
			virtual_profile.update_attributes(params[:user])
			virtual_profile.password = params[:user][:password]
		end
		return virtual_profile
	end

	def get_sorted_competition_entries
		competition_entries = []
		@user.results.each do |r|
			competition = Competition.find_by_id(r.competition_id)
			event = Event.find_by_id(competition.event_id)
			competition_entries << {id: event.id, event: event, competition: competition, result: r}
		end
		competition_entries.sort_by! do |x|
			x[:event].start_date
		end.reverse!
	end

	def update_user_admin
		@user.update_attribute(:admin, params[:admin]) if current_user.admin?
		redirect_to request.referer
	end

	def update_user_author
		@user.update_attribute(:author, params[:author]) if current_user.admin?
		redirect_to request.referer
	end

	def update_user_normal
		params[:user].delete(:password) if params[:user][:password].blank?
		params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank?
		if @user.update_attributes(params[:user])
			flash[:success]= "Profile updated"
			sign_in @user unless @user.registered==false
			redirect_to @user
		else
			render 'edit'
		end
	end

	def anti_spam_verifications
		if params[:challenge].nil? || params[:challenge].match(/^free\s?style.*/i).nil?
			flash[:error] = "Wrong answer to Challenge Question"
			@user = User.new
			render 'new'
			return false
		end
		return true
		# if verify_recaptcha(model: @user, message: "Wrong reCaptcha words, please try again.") && @user.save
	end

	def correct_user
		if !current_user.nil? && !current_user.admin?
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end
end
