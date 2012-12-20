require 'spec_helper'

describe BlogsController do 
	let(:user) { FactoryGirl.create(:user) }
	let(:blog) { FactoryGirl.create(:blog, user: user) }

	before do
		request.env["HTTP_REFERER"] = "where_i_came_from"
		user.modified_user = nil
		user.save!
		user.reload
	end

	describe "show->" do
		before do
			@public_post = blog.blog_posts.new
			@public_post.public = true
			@public_post.content = "I'm public"
			@public_post.save!

			@private_post = blog.blog_posts.new
			@private_post.public = false
			@private_post.content = "I'm public"
			@private_post.save!
		end
		context "when signed out" do
			it "should render show" do
				get :show, id:blog
				response.should render_template :show
			end
			it "should get blog" do
				get :show, id:blog
				assigns(:blog).should_not be_nil
			end
			it "should get public blog posts" do
				get :show, id:blog
				assigns(:blog_posts).should_not be_nil
				assigns(:blog_posts).should include @public_post
				assigns(:blog_posts).should_not include @private_post
			end
		end
		context "when signed in" do
			it "should render show" do
				get :show, id:blog
				response.should render_template :show
			end
			it "should get blog" do
				get :show, id:blog
				assigns(:blog).should_not be_nil
			end
			it "should get public&private blog posts" do
			end
		end
	end

	describe "scrape from modified->" do
		before do
			@blog_url = "http://modified.in/footbag/viewtopic.php?f=14&t=22868"
		end
		context "when user is not signed in" do
			it "shouldn't scrape" do
				expect do
					get :perform_import, blog_url: @blog_url
				end.to_not change(BlogPost, :count)
				response.should redirect_to signin_path
			end
		end
		context "when user is signed in" do
			before do
				sign_in user
			end
			context "and didn't define their modified user" do
				it "shouldn't scrape" do
					expect do
						get :perform_import, blog_url: @blog_url
					end.to_not change(BlogPost, :count)
					response.should redirect_to edit_user_url(user)
				end
			end
			context "and has a modified user" do
				context "but is not the one that wrote the blog" do
					before do
						sign_out
						user.modified_user = "Ass"
						user.save!
						user.reload
						sign_in user
					end
					it "shouldn't scrape" do
						VCR.use_cassette 'controller/blog_scrape' do
							expect do
								get :perform_import, blog_url: @blog_url
							end.to_not change(BlogPost, :count)
						end
					end
				end
				context "and is the user that wrote the blog" do
					before do
						sign_out
						user.modified_user = "boats"
						user.save!
						user.reload
						sign_in user
					end
					it "should scrape" do
						pending "Can't use VCR to test multiple requests on one cassette. Solve some time"
=begin						
						VCR.use_cassette 'controller/blog_scrape' do
							expect do
								get :perform_import, blog_url: @blog_url
							end.to change(BlogPost, :count)
						end
=end								
					end
			
				end
			end
		end
	end
end