class StaticPagesController < ApplicationController
	require 'will_paginate/array' 
  def home
  	if signed_in?
  		@feed_items = current_user.feed.paginate(page: params[:page])
  	else
  		@feed_items = Post.all.paginate(page: params[:page])
  	end

  end
end
