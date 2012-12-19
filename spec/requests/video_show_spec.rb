require 'spec_helper'

describe "video show." do 
	let(:user) { FactoryGirl.create(:user) }
	let(:video) { FactoryGirl.create(:video) }
	subject { page }

	describe "user names->" do
		before do
			video.user_players << user
			video.save!
			visit video_path(video)
		end
		context "when logged out" do
			context "and use has a nickname" do 
				before do
					user.nickname = "nicko"
					user.save!
					visit video_path(video)
				end
				it { should have_link(user.nickname, href:user_path(user)) }
			end
			context "and user doesn't have a nickname" do
				it { should have_link(user.name, href:user_path(user)) }
			end
		end

		context "when logged in" do
			before do
				user.nickname = "nicko"
				user.save!
				sign_in user
				visit video_path(video)
			end
			it { should have_link(user.name, href:user_path(user)) }
		end
	end
	
end