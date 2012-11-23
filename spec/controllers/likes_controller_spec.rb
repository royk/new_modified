require 'spec_helper'

describe LikesController do 

	let(:user) { FactoryGirl.create(:user) }
	let(:user2) { FactoryGirl.create(:user, name: "yayo") }
	let(:video_item) { FactoryGirl.create(:video) }
	let(:post_item) { FactoryGirl.create(:post) }
	let(:like) { FactoryGirl.create(:like) }
	let(:like2) { FactoryGirl.create(:like) }

	before { sign_in user }

	describe "create" do
		context "on video" do
			it "should create a new like and add it to the video object" do
				expect do
					post :create, parent_type: video_item.class, parent_id: video_item
				end.to change(Like, :count).by(1)
				assigns[:response].should_not be_nil
				assigns[:response].should_not eq(like)
				video_item.likes.find(assigns[:response]).should_not be_nil
			end
		end
		context "on post" do
			it "should create a new like and add it to the post object" do
				expect do
					post :create, parent_type: post_item.class, parent_id: post_item
				end.to change(Like, :count).by(1)

				assigns[:response].should_not be_nil
				assigns[:response].should_not eq(like)
				post_item.likes.find(assigns[:response]).should_not be_nil
			end
		end
	end

	describe "destroy" do
		context "with wrong user" do
			before :each do 
				@to_delete = Like.new
				@to_delete.liker = user
				@to_delete.save!
				sign_out_2
				sign_in user2
			end
			it "should not allow to destory" do
				expect do
					delete :destroy, id: @to_delete
				end.to_not change(Like, :count).by(-1)
			end
		end
	end
end