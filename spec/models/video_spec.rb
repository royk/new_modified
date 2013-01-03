# == Schema Information
#
# Table name: videos
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  title        :string(255)
#  vendor       :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  uid          :string(255)
#  url          :string(255)
#  public       :boolean          default(TRUE)
#  location     :string(255)
#  maker        :string(255)
#  players      :text
#  for_feedback :boolean          default(FALSE)
#  feed_id      :integer
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
	it { should respond_to(:players_names) }
	it { should respond_to(:players_list) }
	it { should respond_to(:remove_players) }
	it { should respond_to(:add_player) }

	its(:user) { should==user }

	describe "validation" do
		describe "should be valid without user_id" do
			before { video.user_id = nil }

			it { should be_valid }
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
	describe "players->" do
		describe "players_list" do
			it "should start empty" do
				video.players_list.should be_empty
			end
			it "should include user players" do
				video.user_players << user

				video.players_list.count.should eq 1
				video.players_list[0].should eq user
			end
			it "should include named players" do
				name = "some guy"
				video.players = []
				video.players << name

				video.players_list.count.should eq 1
				video.players_list[0].should eq name
			end
			it "should combine both types of players" do
				video.user_players << user
				name = "some guy"
				video.players = []
				video.players << name

				video.players_list.count.should eq 2
			end
		end
		describe "remove_players" do
			context "when there are no players" do
				it "should not crash" do
					video.remove_players
					video.players_list.count.should eq 0
				end
			end
			context "when there are players" do
				it "should remove them all" do
					video.user_players << user
					name = "some guy"
					video.players = []
					video.players << name

					video.remove_players
					video.players_list.count.should eq 0
				end
			end
		end
		describe "add_player" do
			context "when adding user player" do
				it "should add it and it should appear in the video" do
					video.add_player(user.name)

					video.players_list.count.should eq 1
					video.players_list[0].should eq user
					video.user_players.count.should eq 1
					video.user_players[0].should eq user

					user.appears_in_videos[0].should eq video
				end
			end
			context "when adding a named player" do
				it "should appear in players list" do
					name = "some guy"
					video.add_player(name)

					video.players_list.count.should eq 1
					video.players_list[0].should eq name
					video.players.count.should eq 1
					video.user_players.count.should eq 0
				end
			end
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
		context "named players" do
			before do
				@name = "Some Guy"
				video.add_player(@name)
				video.save!
			end
			context "becoming user players" do
				before do
					@new_user = User.new
					@new_user.name = @name
					@new_user.email = "lala@fofo.com"
					@new_user.admin = false
					@new_user.password = "lalalalal"
					@new_user.password_confirmation = "lalalalal"
					@new_user.save!
				end
				it "should replace named player with the appropriate user player" do
					video.players.count.should eq 1 # precondition
					video.user_players.should be_empty

					Video.move_to_user_players(@new_user)
					video.reload

					video.players.should be_empty
					video.user_players.count.should eq 1
					video.user_players[0].should eq @new_user
				end
				it "should not modify the video's timestamp" do
					prev_updated_at = video.updated_at.dup

					Video.move_to_user_players(@new_user)
					video.reload

					prev_updated_at.to_s.should eq video.updated_at.to_s
				end
			end
		end
		context "user players" do
			before do
				video.add_player(user.name)
				video.save!
			end
			context "becoming a named player" do
				it "should replace user player with named player" do
					video.user_players.count.should eq 1 # precondition
					video.players.should be_empty

					video.move_to_named_players(user)
					video.reload

					video.players.count.should eq 1
					video.user_players.should be_empty
				end
				it "should not modify the video's timestamp" do
					prev_updated_at = video.updated_at.dup

					video.move_to_named_players(user)
					video.reload

					prev_updated_at.to_s.should eq video.updated_at.to_s
				end
			end
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
