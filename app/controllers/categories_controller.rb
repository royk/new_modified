class CategoriesController < AuthenticatedController
	before_filter :admin_only

	def create
		@category = Category.new(params[:category])
		if @category.save
			flash[:success] = "Created category #{@category.name}"
			redirect_to root_url
		else
			flash[:error] = "Couldn't create category!"
			render 'new'
		end
	end

	def new
		@category = Category.new
	end

	private
		def admin_only
			redirect_to root_url unless current_user.admin?
		end

end