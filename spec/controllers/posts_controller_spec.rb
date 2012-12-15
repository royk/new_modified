require 'spec_helper'

describe PostsController do 
	let(:user) { FactoryGirl.create(:user) }
	let(:post) { FactoryGirl.create(:post, user: user) }

	before do
		request.env["HTTP_REFERER"] = "where_i_came_from"
	end

	shared_examples_for "a successful get" do
		it "should get the correct post" do
			get :show, id: post
			assigns(:post).should eq(post)
		end
	end

	describe "show->" do
		context "when logged out" do
			context "and getting public post" do
				it_behaves_like "a successful get"
			end
			context "and getting private post" do
				before do
					post.public = false
					post.save!
				end
				it "should not return the post" do
					get :show, id: post
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
					post.public = false
					post.save!
				end
				it_behaves_like "a successful get"
			end
		end
	end
	describe "edit->" do
		context "when logged out" do
			it "should not allow editing" do
				get :edit, id:post
				response.should_not render_template :edit
			end
		end
		context "when signed in" do
			context "with the owner user" do
				before do
					sign_in user
				end
				it "should allow editing" do
					get :edit, id:post
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
					get :edit, id:post
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
					get :edit, id:post
					response.should render_template :edit
				end
			end
		end
	end

end