require 'spec_helper'

describe LikesController do 

	let(:user) { FactoryGirl.create(:user) }
	let(:video) { FactoryGirl.create(:video) }
	let(:like) { FactoryGirl.create(:like) }

	before { sign_in user }

	describe "create" do
		it "should assign to :like" do
			expect do
				post :create, content: "yay", parent_type: video.class, parent_id: video
			end.to change(Like, :count).by(1)

			assigns[:response].should_not be_nil
			assigns[:response].should_not eq(like)
			video.likes.find(assigns[:response]).should_not be_nil
		end
	end
end