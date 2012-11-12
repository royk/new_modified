class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		@feed_items = current_user.feed.paginate(page: params[:page])
  	end
  end
end
