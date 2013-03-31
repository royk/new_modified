require 'spec_helper'
describe "activity bar" do 
	let(:user) { FactoryGirl.create(:user) }
	let(:post_item) { FactoryGirl.create(:post) }
	let(:comment) { FactoryGirl.create(:comment) }
	let(:like) { FactoryGirl.create(:like) }

	subject { find("ul.activities") }
	before { sign_in user }

	describe "when there are no activities" do
		before { visit root_path }
		it { should_not have_css("li") }
	end

	describe "when there's an activity notification" do
		before :each do
			notification = Notification.new
			notification.item = comment
			notification.sender = user
			notification.parent_item = post_item
			notification.public = true
			notification.save!
			visit root_path
		end
		it { should have_css("li", count: 1) }
		it { should have_link(user.shown_name, href: user_path(user)) }
		it { should have_link(post_item.class.to_s.downcase, href: post_path(post_item)) }

		context "and it's about a comment that got a like" do
			before do
				comment.commentable = post_item
				comment.save!
				notification = Notification.new
				notification.item = like
				notification.sender = user
				notification.parent_item = comment
				notification.public = true
				notification.save!
				visit root_path
			end

			it { should have_link("comment", href: post_path(comment.commentable)) }
		end
		context "and it's about a video" do
			before do
				@video = FactoryGirl.create(:video)
				@video.save!
				notification = Notification.new
				notification.item = @video
				notification.sender = user
				notification.public = true
				notification.save!
				visit root_path
			end
			it { should have_link("video", href: video_path(@video)) }
			context "for feedback" do
				before do
					@video.for_feedback = true
					@video.save!
					notification = Notification.new
					notification.item = @video
					notification.sender = user
					notification.public = true
					notification.save!
					visit root_path
				end
				it { should have_link("feedback video", href: video_path(@video)) }
			end
		end

	end
end