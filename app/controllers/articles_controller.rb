class ArticlesController < AuthenticatedController
	include ContentControls

	before_filter	:correct_user, only: [:destroy, :edit]
	before_filter   :author, only: [:create]
	skip_before_filter :signed_in_user, only: [:index, :show]

	def show
		@article = get_item_permalink(Article, params)
	end

	def edit
		@article = get_item_permalink(Article, params)
		edit! { request.referer }
	end

	def create
		create! do |success, failure|
			success.html do 
				register_new_content(@article)
				redirect_to request.referer
			end
			failure.html do
				flash[:error] = "Could not create article. It must have a unique title and some content."
				redirect_to request.referer
			end
		end
	end

	def index
		@articles = publishing_query(Article).paginate(page: params[:page], :per_page => 10)
	end

	def update
		@article = Article.find_by_permalink(params[:id])
		update! { articles_path }
	end

	def destroy
		@article = Article.find_by_permalink(params[:id])
		destroy! { request.referer }
	end

	private

		def author
			unless current_user.admin? || current_user.author?
				redirect_to root_url
			end
		end
		
		def begin_of_association_chain
			current_user
		end

		def correct_user
			if !current_user.admin?
				@article = current_user.articles.find_by_permalink(params[:id])
				redirect_to root_url if @article.nil?
			end
		end
end