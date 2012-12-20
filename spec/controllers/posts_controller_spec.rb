require 'spec_helper'

describe PostsController do 
	let(:user) { FactoryGirl.create(:user) }
	let(:post_item) { FactoryGirl.create(:post, user: user) }

	before do
		request.env["HTTP_REFERER"] = "where_i_came_from"
	end

	shared_examples_for "a successful get" do
		it "should get the correct post" do
			get :show, id: post_item
			assigns(:post).should eq(post_item)
		end
	end

	describe "create->" do
		before { @content = "new post content" }
		context "when signed out" do
			it "should not create" do
				expect do
					post :create, post: {content: @content}
				end.to_not change(Post, :count)
			end
		end
		context "when signed in" do
			before { sign_in user }
			it "should create" do
				expect do
					post :create, post: {content: @content}
				end.to change(Post, :count).by 1
			end
			it "should create a notification" do
				expect do
					post :create, post: {content: @content}
				end.to change(Notification, :count).by 1
			end
		end

	end

	describe "show->" do
		context "when logged out" do
			context "and getting public post" do
				it_behaves_like "a successful get"
			end
			context "and getting private post" do
				before do
					post_item.public = false
					post_item.save!
				end
				it "should not return the post" do
					get :show, id: post_item
					assigns(:post).should be_nil
					response.should_not render_template :show
				end
			end
		end
		context "when logged in" do
			before do
				sign_in user
			end
			context "and getting public post" do
				it_behaves_like "a successful get"
			end
			context "and getting private post" do
				before do
					post_item.public = false
					post_item.save!
				end
				it_behaves_like "a successful get"
			end
		end
	end
	describe "edit->" do
		context "when logged out" do
			it "should not allow editing" do
				get :edit, id:post_item
				response.should_not render_template :edit
			end
		end
		context "when signed in" do
			context "with the owner user" do
				before do
					sign_in user
				end
				it "should allow editing" do
					get :edit, id:post_item
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
					get :edit, id:post_item
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
				it "should allow editing" do
					get :edit, id:post_item
					response.should render_template :edit
				end
			end
		end
	end

end