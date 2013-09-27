require 'spec_helper'

describe LikesController do 

	let(:user) { FactoryGirl.create(:user) }
	let(:user2) { FactoryGirl.create(:user, name: "yayo") }
	let(:video_item) { FactoryGirl.create(:video) }
	let(:post_item) { FactoryGirl.create(:post) }
	let(:like) { FactoryGirl.create(:like) }
	let(:like2) { FactoryGirl.create(:like) }

	before do
		request.env["HTTP_REFERER"] = "where_i_came_from"
	end

	describe "create" do
		context "when signed out" do
			before { sign_out }
			it "should not be allowed" do
				expect do
					post :create, parent_type: video_item.class, parent_id: video_item
				end.to_not change(Like, :count).by(1)
			end
		end
		context "when signed in" do
			before { sign_in user }
			context "video" do
				it "should be liked" do
					expect do
						post :create, parent_type: video_item.class, parent_id: video_item
					end.to change(Like, :count).by(1)
					assigns[:response].should_not be_nil
					assigns[:response].should_not eq(like)
					video_item.likes.find(assigns[:response]).should_not be_nil
				end
				it "should not be liked twice by same user" do
					expect do
						post :create, parent_type: video_item.class, parent_id: video_item
						post :create, parent_type: video_item.class, parent_id: video_item
					end.to_not change(Like, :count).by(2)
				end
			end
			context "post" do
				it "should be liked" do
					expect do
						post :create, parent_type: post_item.class, parent_id: post_item
					end.to change(Like, :count).by(1)

					assigns[:response].should_not be_nil
					assigns[:response].should_not eq(like)
					post_item.likes.find(assigns[:response]).should_not be_nil
				end
			end
			context "notifications:" do
				context "when liking my own post" do
					before do 
						post_item.user = user
						post_item.save!
					end
					it "should create a public notification" do
						post_item.user.should eq user # sanity
						expect do
							post :create, parent_type: post_item.class, parent_id: post_item
						end.to change(Notification, :count).by 1
          end
=begin
					it "should change the updated timestamp of the post" do
						post_item.user.should eq user # sanity
						beforeStamp = post_item.updated_at.to_s
						Timecop.travel(Time.now + 1.year) do
							post :create, parent_type: post_item.class, parent_id: post_item
							post_item.reload
							afterStamp = post_item.updated_at.to_s
							beforeStamp.should_not eq afterStamp
						end
					end
=end
				end
				context "when liking someone else's post" do
					it "should create public and private notifications" do
          end
=begin
					it "should change the updated timestamp of the post" do
						post_item.user.should_not eq user # sanity
						beforeStamp = post_item.updated_at.to_s
						Timecop.travel(Time.now + 1.year) do
							post :create, parent_type: post_item.class, parent_id: post_item
							post_item.reload
							afterStamp = post_item.updated_at.to_s
							beforeStamp.should_not eq afterStamp
						end
					end
=end
				end
			end
		end
	end

	describe "destroy" do
		before :each do
			@to_delete = video_item.likes.create
			@to_delete.liker = user
			@to_delete.save!
		end
		context "with wrong user" do
			before do 
				sign_in user2
			end
			it "should be not allowed" do
				expect do
					delete :destroy, parent_type: video_item.class, parent_id: video_item
				end.to_not change(Like, :count).by(-1)
			end
		end
		context "with right user" do
			before do
				sign_in user
			end
			context "with wrong object" do
				it "should not destroy" do
					expect do
						delete :destroy, parent_type: post_item.class, parent_id: post_item
					end.to_not change(Like, :count).by(-1)
				end
			end

			it "should destroy" do
				expect do
					delete :destroy, parent_type: video_item.class, parent_id: video_item
				end.to change(Like, :count).by(-1)
			end
		end
	end
end