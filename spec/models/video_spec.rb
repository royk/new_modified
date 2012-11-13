# == Schema Information
#
# Table name: videos
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  user_id    :integer
#  title      :string(255)
#  type       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Video do
	before(:all)  { User.delete_all }

	let!(:user) { FactoryGirl.create(:user) }
	let!(:video) { user.videos.build(title: "title", url: "http://www.youtube.com/watch?feature=player_embedded&v=svDPNjQV3ak") }
	let!(:invalid_video) { user.videos.build(title: "title", url: "lala") }

	subject { video }

	it { should be_valid}

	it { should respond_to(:title) }
	it { should respond_to(:url) }
	it { should respond_to(:user) }
	it { should respond_to(:user_id) }

	its(:user) { should==user }

	describe "validation" do
		describe "should not be valid without user_id" do
			before { video.user_id = nil }

			it { should_not be_valid }
		end

		describe "should not be valid withoutt url" do
			before { video.url = nil }

			it { should_not be_valid }
		end
	end

	describe "when url is already taken" do
		before do
			vid_same_url = video.dup
			vid_same_url.url = video.url.upcase
			vid_same_url.save
		end
		it {should_not be_valid}
	end
end
