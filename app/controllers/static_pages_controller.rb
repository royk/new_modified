class StaticPagesController < ApplicationController
	include ApplicationHelper
	require 'will_paginate/array' 
	before_filter :check_for_mobile

	def chat
		render layout: false
	end

	def home
	  	@first_timer = first_time_visitor?
	  	if mobile_device? || signed_in? || request.xhr?
	  		@feed_front_page = true
		  	per_page = params[:items_count] || 10
			logger.debug "Start"
		  	@feed = Feed.find_by_store_name("main feed")
			logger.debug "1"
	  		@feed = seed_main_feed if @feed.nil?
			logger.debug "2"
			@feed_items = @feed.feed_items([BlogPost, Achievement]) do |collection|
				privacy_query(collection)
			end
			logger.debug "3"
			@feed_items = @feed_items.paginate(page: params[:page], :per_page=> per_page)
			logger.debug "4"
			if mobile_device?
				@feeds = Feed.where("hidden = ?", false)
			end
			logger.debug "5"
			if request.xhr?
				render partial: 'shared/feed_item', collection: @feed_items, comments_shown: false
			end
		else
			@full_site_layout = true	
			@feed_front_page = false
			@article = Article.find_by_permalink("front-page")
		end
	end

	def admin 
		@feed = Feed.find_by_store_name("admin feed")
		@feed = seed_admin_feed if @feed.nil?
		@feed_items = @feed.feed_items.paginate(page: params[:page], per_page: 10)
		@virtual_profiles = User.where(registered: false)
		if request.xhr?
			render partial: 'shared/feed_item', collection: @feed_items, comments_shown: false
		end
	end



end
