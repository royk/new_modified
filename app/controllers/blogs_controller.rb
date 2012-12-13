class BlogsController < AuthenticatedController
	include BlogScraping
	include UsersHelper

	skip_before_filter :signed_in_user, only: [:index, :show]
	
	def index
		@blogs = Blog.paginate(page: params[:page], :per_page => 10)

	end

	def show
		@blog = Blog.find(params[:id])
		@blog_posts = privacy_query(@blog.blog_posts).paginate(page: params[:page], :per_page => 10)
		if request.xhr?
			render partial: 'shared/feed_item', collection: @blog_posts, comments_shown: false
		end
	end

	def import
		unless current_user.admin?
			redirect_to root_url
		end
	end

	def perform_import
		unless current_user.modified_user.nil?
			posts = scrape(params[:blog_url], current_user.modified_user) unless params[:blog_url].empty?
			unless posts.nil?
				create_posts(posts)
				redirect_to root_url
			else
				flash[:errors] = "Couldn't import blog. Please make sure that your Modified user name is correct and that the url you entered directs to the first page of your blog."
				redirect_to request.referer
			end

			
		else
			flash[:errors] = "You must set your Modified user name in order to import your blog"
			redirect_to edit_user_url(current_user)
		end
	end

	private
		def create_posts(posts)
			create_blog(current_user) if current_user.blog.nil?
			posts.each do |p|
				post = current_user.blog.blog_posts.build()
				post.record_timestamps = false
				post.content = p[:content]
				post.created_at = p[:date]
				post.updated_at = p[:date]
				p[:comments].each do |c|
					comment = post.comments.build()
					comment.record_timestamps = false
					comment.content = c[:content]
					comment.commenter_name = c[:author]
					comment.created_at = c[:date]
					comment.updated_at = c[:date]
					comment.record_timestamps = true
					comment.save
				end
				post.save
				post.record_timestamps = true
			end
		end
end