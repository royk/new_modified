# == Schema Information
#
# Table name: videos
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  title      :string(255)
#  type       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  uid        :string(255)
#

require 'spec_helper'

describe Video do
	before(:all)  { User.delete_all }

	let!(:user) { FactoryGirl.create(:user) }
	let!(:video) { user.videos.build(title: "title", uid: "svDPNjQV3ak", vendor: "youtube") }

	subject { video }

	it { should be_valid}

	it { should respond_to(:title) }
	it { should respond_to(:uid) }
	it { should respond_to(:user) }
	it { should respond_to(:user_id) }
	it { should respond_to(:vendor) }

	its(:user) { should==user }

	describe "validation" do
		describe "should not be valid without user_id" do
			before { video.user_id = nil }

			it { should_not be_valid }
		end

		describe "should not be valid without uid" do
			before { video.uid = nil }

			it { should_not be_valid }
		end

		describe "should not be valid without vendor" do
			before { video.vendor = nil }

			it { should_not be_valid }
		end
	end



	describe "when uid is already taken" do
		before do
			vid_same_url = video.dup
			vid_same_url.uid = video.uid
			vid_same_url.save
		end
		it {should_not be_valid}
	end
end
