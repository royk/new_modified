# == Schema Information
#
# Table name: videos
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  title      :string(255)
#  vendor     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  uid        :string(255)
#  url        :string(255)
#  public     :boolean          default(TRUE)
#  location   :string(255)
#  maker      :string(255)
#  players    :text
#

require 'spec_helper'

describe Video do
	before(:all)  { User.delete_all }

	let!(:user) { FactoryGirl.create(:user) }
	let!(:video) { FactoryGirl.create(:video, user: user) }

	subject { video }

	it { should be_valid}

	it { should respond_to(:title) }
	it { should respond_to(:uid) }
	it { should respond_to(:user) }
	it { should respond_to(:user_id) }
	it { should respond_to(:vendor) }
	it { should respond_to(:url) }
	it { should respond_to(:public) }
	it { should respond_to(:location) }
	it { should respond_to(:maker) }
	it { should respond_to(:players) }
	it { should respond_to(:user_players) }

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

		it { should have_and_belong_to_many(:user_players) }
	end

	context "user players" do
		it "should not allow the same player twice" do
			video.user_players.count.should eq 0
			video.user_players << user
			video.user_players.count.should eq 1
			video.user_players << user
			video.user_players.count.should eq 1
		end
	end



	describe "when uid is already taken" do
		before do
			@vid_same_url = video.dup
			@vid_same_url.uid = video.uid
			@vid_same_url.save
		end
		subject { @vid_same_url }
		it {should_not be_valid}
	end
end
