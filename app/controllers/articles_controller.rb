class ArticlesController < AuthenticatedController
	include ContentControls

	before_filter	:correct_user, only: [:destroy, :edit]
	before_filter   :author, only: [:create]
	skip_before_filter :signed_in_user, only: [:index, :show]

	def new
		@full_site_layout = true
	end

	def show
		@full_site_layout = true
		@article = get_item_permalink(Article, params)
		author() if !@article.published
		if @article.public==false && signed_in?()==false
			redirect_to request.referer
		end
	end

	def edit
		@full_site_layout = true
		@article = get_item_permalink(Article, params)
		edit! { request.referer }
	end

	def create
		if params[:publishing_option]=="private"
			params[:public] = false
			params[:published] = false
		end
		if params[:publishing_option]=="protected"
			params[:public] = false
			params[:published] = true
		end
		if params[:publishing_option]=="public"
			params[:public] = true
			params[:published] = true
		end
		params.delete(:publishing_option)
		create! do |success, failure|
			success.html do
				@article.public = params[:public]
				@article.published = params[:published]
				@article.save
				register_new_content(@article)
				redirect_to articles_path
			end
			failure.html do
				flash[:error] = "Could not create article. It must have a unique title and some content."
				redirect_to request.referer
			end
		end
	end

	def index
		@full_site_layout = true
		@categories = Category.order("weight ASC").all
		@empty_category = Category.new
		@empty_category.name = t(:others)
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
		destroy! { root_url }
	end

	private
		def author
			if !signed_in?
				redirect_to root_url
				return
			end
			can_write = current_user.admin? || current_user.author?
			if !can_write
				flash[:error] = "You need Author credentials to write an article."
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