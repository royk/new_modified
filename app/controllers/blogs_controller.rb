class BlogsController < AuthenticatedController
	require 'will_paginate/array'

	include BlogScraping
	include UsersHelper

	skip_before_filter :signed_in_user, only: [:index, :show]
	
	def index
		@full_site_layout = true
		@blogs = Blog.order("featured desc")
	end

	def update
		blog = Blog.find(params[:id])
		unless blog.update_attribute(:featured, params[:featured])
			flash[:error] = "Could not create article. It must have a unique title and some content."
		end
		redirect_to request.referer

	end

	def show
		@full_site_layout = true
		@blog = Blog.find(params[:id])
		all_posts = privacy_query(@blog.blog_posts)
		per_page = 10
		@current_page = params[:page]
		@current_page = 1 if @current_page.nil?
		@blog_posts = all_posts.paginate(page: @current_page, :per_page => per_page)
		@total_pages = (all_posts.count / per_page).floor + 1
		if request.xhr?
			render partial: 'shared/feed_item', collection: @blog_posts, comments_shown: false, total_pages: @total_pages, current_page: @current_page
		end
	end
	def rename
		@blog = Blog.find(params[:id])
		if (@blog.nil? || params[:title].empty?)
			render text: ""
		else
			@blog.update_attribute(:title, params[:title])
			@blog.save!
			render text: @blog.title
		end
	end

	def import
		@full_site_layout = true
  		@bright_body = true
	end

	def init_blog
		@full_site_layout = true
		create_blog(current_user) if current_user.blog.nil?
		if current_user.save_without_signout
			redirect_to current_user.blog
		else
			flash[:errors] = "Couldn't create blog."
			redirect_to request.referer
		end
	end

	def perform_import
		@full_site_layout = true
  		@bright_body = true
		unless current_user.modified_user.nil?
			posts = scrape_modified(params[:blog_url], current_user.modified_user) unless params[:blog_url].empty?
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

	def perform_blogpost_import
		@full_site_layout = true
  		@bright_body = true
		posts = scrape_blogspot(params[:feed_url])
		unless posts.nil?
			create_posts(posts)
			redirect_to root_url
		else
			flash[:errors] = "Couldn't import from this feed."
			redirect_to request.referer
		end

	end

	private
		def create_posts(posts)
			create_blog(current_user) if current_user.blog.nil?
			posts.each do |p|
				# don't add the post if its timestamp already exists (i.e. it's most probably a duplicate)
				unless current_user.blog.blog_posts.where("created_at = ? or updated_at = ?", p[:date], p[:date]).any?
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
end