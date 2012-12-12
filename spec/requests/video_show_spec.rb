require 'spec_helper'

describe "video show." do 
	let(:user) { FactoryGirl.create(:user) }
	let(:video) { FactoryGirl.create(:video) }
	subject { page }

	describe "user names->" do
		before do
			user.nickname = "nicko"
			user.save!
			video.user_players << user
			video.save!
			visit video_path(video)
		end
		context "when logged out" do
			it { should have_link(user.nickname, href:user_path(user)) }
		end

		context "when logged in" do
			before do
				sign_in user
				visit video_path(video)
			end
			it { should have_link(user.name, href:user_path(user)) }
		end
	end
	
end