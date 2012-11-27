class StaticPagesController < ApplicationController
	require 'will_paginate/array' 
  def home
  	per_page = params[:items_count] || 10
	@feed_items = (privacy_query(Post) + privacy_query(Video)).sort_by {|f| -f.created_at.to_i} # sort by descending by converting to int and negating
	@feed_items = @feed_items.paginate(page: params[:page], :per_page=> per_page)	
	if request.xhr?
		render partial: 'shared/feed_item', collection: @feed_items, comments_shown: false
	end
  end


end
