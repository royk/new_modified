class StaticPagesController < ApplicationController
	require 'will_paginate/array' 
  def home
  	current_user ||= User.new
	@feed_items = current_user.feed.paginate(page: params[:page])
  end
end
