require 'spec_helper'

describe BlogPostsController do 
	let(:user) { FactoryGirl.create(:user) }
	let(:blog) { FactoryGirl.create(:blog, user: user) }
	let(:blog_post) { FactoryGirl.create(:blog_post, blog: blog) }

	before do
		request.env["HTTP_REFERER"] = "where_i_came_from"
	end

	describe "create->" do
		before do
			@blog_post = BlogPost.new
			@blog_post.content = "yay blog"
			@user2 = User.new
			@user2.name = "loko boko"
			@user2.email = "lala@fofo.com"
			@user2.admin = false
			@user2.password = "lalalalal"
			@user2.password_confirmation = "lalalalal"
			@user2.save!
			sign_in @user2
		end
		context "when doesn't have a blog yet" do
			it "should create a new blog" do
				post :create, blog_post: @blogPost
				@user2.blog.should_not be_nil
			end
		end
	end

	describe "edit->" do
		context "when logged out" do
			it "should not allow editing" do
				get :edit, id:blog_post
				response.should_not render_template :edit
			end
		end
		context "when signed in" do
			context "with the owner user" do
				before do
					sign_in user
				end
				it "should allow editing" do
					get :edit, id:blog_post
					response.should render_template :edit
				end
			end
			context "with a non-owner user" do
				before do
					@non_owner = User.new
					@non_owner.name = "loko boko"
					@non_owner.email = "lala@fofo.com"
					@non_owner.admin = false
					@non_owner.password = "lalalalal"
					@non_owner.password_confirmation = "lalalalal"
					@non_owner.save!
					sign_in @non_owner
				end
				it "should not allow editing" do
					get :edit, id:blog_post
					response.should_not render_template :edit
				end
			end
			context "with a non-owner admin" do
				before do
					@non_owner = User.new
					@non_owner.name = "loko boko"
					@non_owner.email = "lala@fofo.com"
					@non_owner.admin = true
					@non_owner.password = "lalalalal"
					@non_owner.password_confirmation = "lalalalal"
					@non_owner.save!
					sign_in @non_owner
				end
				it "should not allow editing" do
					get :edit, id:blog_post
					response.should render_template :edit
				end
			end
		end
	end
end