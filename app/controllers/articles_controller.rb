class ArticlesController < AuthenticatedController
	include ContentControls

	before_filter	:correct_user, only: [:destroy, :edit]
	before_filter   :author, only: [:create]
	skip_before_filter :signed_in_user, only: [:index, :show]

	def show
		@full_site_layout = true
		@article = get_item_permalink(Article, params)
	end

	def edit
		@full_site_layout = true
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
		@full_site_layout = true
    	@bright_body = true
		@categories = Category.all
		@empty_category = Category.new
		@empty_category.name = t(:unsorted)
		@empty_category.articles = Article.where("category_id = ?", nil)
	end

	def update
		@article = Article.find_by_permalink(params[:id])
		if @article.update_attributes(params[:article])
			redirect_to articles_path 
		else
			flash[:error] = "Could not create article. It must have a unique title and some content."
			redirect_to request.referer
		end

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