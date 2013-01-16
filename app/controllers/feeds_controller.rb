class FeedsController < AuthenticatedController
	require 'will_paginate/array' 
	before_filter	:correct_user, only: [:destroy, :edit]
	skip_before_filter :signed_in_user, only: [:index, :show]

	def index
		@to_exclude = ["Main Feed", "Admin Feed"]
		@feeds = Feed.all
	end

	def show
		@feed = Feed.find_by_permalink(params[:permalink].downcase)
		if @feed.nil?
			@feed = Feed.find_by_store_name(params[:permalink].downcase)
		end
		unless @feed.nil?
			@feed_items = @feed.feed_items do |collection|
				privacy_query(collection)
			end
			@feed_items = @feed_items.paginate(page: params[:page], :per_page=> 10)
			if request.xhr?
				render partial: 'shared/feed_item', collection: @feed_items, comments_shown: false
			end
		else
			render :status => 500
		end
	end

	def create
		@feed = Feed.create(params[:feed])
		@feed.user = current_user
		if @feed.save
			flash[:success] = "Created a new feed"
		else
			flash[:error] = "Failed creating feed. Only alphanumeric and the minus character are allowed in the URL."
		end
		redirect_to request.referer
	end

	def update
		@feed = Feed.find(params[:id])
		@feed.update_attributes(params[:feed])
		redirect_to request.referer
	end

	def edit
		edit! { feeds_path }
	end

	private
		def correct_user
			unless current_user.admin?
				@feed = current_user.feeds.find_by_id(params[:id])
				redirect_to root_url if @feed.nil?
			end
		end
end