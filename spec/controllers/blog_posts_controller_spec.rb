require 'spec_helper'

describe BlogPostsController do 
	let(:user) { FactoryGirl.create(:user) }

	before do
		request.env["HTTP_REFERER"] = "where_i_came_from"
		sign_in user
	end

	describe "create->" do
		before do
			@blog_post = BlogPost.new
			@blog_post.content = "yay blog"
		end
		context "when doesn't have a blog yet" do
			it "should create a new blog" do
				post :create, blog_post: @blogPost
				user.blog.should_not be_nil
			end
		end
	end
end