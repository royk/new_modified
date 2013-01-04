class StaticPagesController < ApplicationController
	include ApplicationHelper
	require 'will_paginate/array' 
	def home
	  	@first_timer = first_time_visitor?
	  	per_page = params[:items_count] || 10
	  	@feed = Feed.find_by_store_name("main feed")
	  	if @feed.nil?
	  		@feed = seed_main_feed
	  	end
		@feed_items = @feed.feed_items do |collection|
			privacy_query(collection)
		end
		@feed_items = @feed_items.paginate(page: params[:page], :per_page=> per_page)
		if request.xhr?
			render partial: 'shared/feed_item', collection: @feed_items, comments_shown: false
		end
	end
end
