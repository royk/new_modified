class ArticlesController < AuthenticatedController
	include ContentControls

	before_filter	:correct_user, only: [:destroy, :edit]
	skip_before_filter :signed_in_user, only: [:index, :show]

	def show
		@article = get_item(Article, params)
	end

	def edit
		@article = Article.find(params[:id])
		edit! { request.referer }
	end

	def create
		create! do |success, failure|
			success.html do 
				notify_activity_on(@article, current_user, nil)
				redirect_to request.referer
			end
			failure.html do
				redirect_to request.referer
			end
		end
	end

	def index
		if signed_in?
			if (current_user.admin? || current_user.author?)
				@articles = Article.all
			else
				@articles = Article.where(published: true)
			end
		else
			@articles = Article.where("public = ? AND published = ?", true, true)
		end
		@articles = @articles.paginate(page: params[:page], :per_page => 10)
	end

	def update
		@article = Article.find(params[:id])
		update! { request.referer }
	end

	def destroy
		@article = Article.find(params[:id])
		destroy! { request.referer }
	end

	private
		def begin_of_association_chain
			current_user
		end

		def correct_user
			if !current_user.admin?
				@article = current_user.articles.find_by_id(params[:id])
				redirect_to root_url if @article.nil?
			end
		end
end