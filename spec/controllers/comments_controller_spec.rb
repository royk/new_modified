require 'spec_helper'

describe CommentsController do 

	let(:user) { FactoryGirl.create(:user) }
	let(:user2) { FactoryGirl.create(:user, name: "yayo") }
	let(:video_item) { FactoryGirl.create(:video) }
	let!(:post_item) { FactoryGirl.create(:post) }
	let(:comment) { FactoryGirl.create(:comment) }
	
	before do
		request.env["HTTP_REFERER"] = "where_i_came_from"
	end

	describe "create->" do
		context "when signed out" do
			before { sign_out }
			it "should not be allowed" do
				expect do
					post :create, parent_type: video_item.class, parent_id: video_item, comment: {content: "yay"}
				end.to_not change(Comment, :count).by(1)
			end
		end
		context "when signed in" do
			before { sign_in user }
			context "video" do
				it "should be commented" do
					expect do
						post :create, parent_type: video_item.class, parent_id: video_item, comment: {content: "yay"}
					end.to change(Comment, :count).by(1)
					assigns[:response].should_not be_nil
					assigns[:response].should_not eq(comment)
					video_item.comments.find(assigns[:response]).should_not be_nil
				end
				it "should be commented twice by same user" do
					expect do
						post :create, parent_type: video_item.class, parent_id: video_item, comment: {content: "yay"}
						post :create, parent_type: video_item.class, parent_id: video_item, comment: {content: "yay"}
					end.to change(Comment, :count).by(2)
					video_item.comments.find(assigns[:response]).should_not be_nil
				end
			end
			context "post" do
				it "should be commented" do
					expect do
						post :create, parent_type: post_item.class, parent_id: post_item, comment: {content: "yay"}
					end.to change(Comment, :count).by(1)

					assigns[:response].should_not be_nil
					assigns[:response].should_not eq(comment)
					post_item.comments.find(assigns[:response]).should_not be_nil
				end
			end
			context "notifications:" do
				context "when commenting on my own post" do
					before do 
						post_item.user = user
						post_item.save!
					end
					it "should create a public notification" do
						post_item.user.should eq user # sanity
						expect do
							post :create, parent_type: post_item.class, parent_id: post_item, comment: {content: "yay"}
						end.to change(Notification, :count).by 1
					end
					it "should change the updated timestamp of the post" do
						post_item.user.should eq user # sanity
						beforeStamp = post_item.updated_at.to_s
						Timecop.travel(Time.now + 1.year) do
							post :create, parent_type: post_item.class, parent_id: post_item, comment: {content: "yay"}
							post_item.reload
							afterStamp = post_item.updated_at.to_s
							beforeStamp.should_not eq afterStamp
						end
					end
				end
				context "when commenting on someone else's post" do
					it "should create public and private notifications" do
					end
					it "should change the updated timestamp of the post" do
						post_item.user.should_not eq user # sanity
						beforeStamp = post_item.updated_at.to_s
						Timecop.travel(Time.now + 1.year) do
							post :create, parent_type: post_item.class, parent_id: post_item, comment: {content: "yay"}
							post_item.reload
							afterStamp = post_item.updated_at.to_s
							beforeStamp.should_not eq afterStamp
						end
					end
				end
			end
		end
	end

	describe "destroy" do
		before :each do
			@to_delete = video_item.comments.create()
			@to_delete.content = "yay"
			@to_delete.commenter = user
			@to_delete.save!
		end
		context "with wrong user" do
			before do 
				sign_in user2
			end
			it "should be not allowed" do
				expect do
					delete :destroy, id: @to_delete
				end.to_not change(Comment, :count).by(-1)
				video_item.comments.should_not be_empty
			end
		end
		context "with right user" do
			before do
				sign_in user
			end
			it "should destroy" do
				expect do
					delete :destroy, id: @to_delete
				end.to change(Comment, :count).by(-1)
				video_item.comments.should be_empty
			end
		end
	end
end