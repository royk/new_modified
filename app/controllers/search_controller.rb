class SearchController < AuthenticatedController
	def search_all
		@search = Sunspot.search [Article, BlogPost, Post, Video] do
			keywords(params[:q])
			order_by :created_at, :desc
			paginate :page => params[:page], :per_page => 10
		end
		@counter = 0
		@counter = (params[:page].to_i-1) * 10 unless params[:page].nil?
		if request.xhr?
			render partial: '/search/results_batch'
		else
			render template: "search/results"
		end
	end
end