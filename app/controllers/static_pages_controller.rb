class StaticPagesController < ApplicationController
	include ApplicationHelper
	require 'will_paginate/array' 
	def home
	  	@first_time = first_time_visitor?
	  	per_page = params[:items_count] || 10
		@feed_items = Post.where(sticky: true).order("updated_at DESC") + ((privacy_query(Post.where(sticky: false)) + privacy_query(Video)).sort_by {|f| -f.updated_at.to_i}) # sort by descending by converting to int and negating
		@feed_items = @feed_items.paginate(page: params[:page], :per_page=> per_page)	
		if request.xhr?
			render partial: 'shared/feed_item', collection: @feed_items, comments_shown: false
		end
	end
end
