class FeedsController < AuthenticatedController
	
	before_filter	:correct_user, only: [:destroy, :edit]
	skip_before_filter :signed_in_user, only: [:index, :show]

	def index
		@feeds = Feed.all
	end

	def show
		@feed = Feed.find_by_store_name(params[:name].downcase)
		@feed_items = @feed.feed_items do |collection|
			privacy_query(collection)
		end
		@feed_items = @feed_items.paginate(page: params[:page], :per_page=> 10)
		if request.xhr?
			render partial: 'shared/feed_item', collection: @feed_items, comments_shown: false
		end
	end
end
