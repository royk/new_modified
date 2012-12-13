require 'spec_helper'

describe PostsController do 
	let(:user) { FactoryGirl.create(:user) }
	let(:post) { FactoryGirl.create(:post) }

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
end