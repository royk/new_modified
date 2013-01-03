require 'spec_helper'
describe "main feed" do 
	let(:user) { FactoryGirl.create(:user) }
	let(:post_item) { FactoryGirl.create(:post) }
	let(:video_item) { FactoryGirl.create(:video) }
	let(:comment) { FactoryGirl.create(:comment) }
	let(:main_feed) { Feed.find_by_name("Main Feed") }

	subject { find("div.front-page-feed") }
	before { visit root_path }

	shared_examples "feed post" do
		it { should have_selector(".feed-item-container > .feed-item")}
		it { should have_selector(".feed-item-container > .post-footer")}
		it { should have_selector(".feed-item-container > .comment-container")}
	end


	describe "posting form->" do
		context "when logged out" do
			it { should_not have_css("div#feed-form") }
		end

		context "when signed in" do
			before do
				sign_in user
				visit root_path
			end
			it { should have_css("div#feed-form") }
		end
	end



	describe "posts->" do
		context "when there aren't any" do
			it { should_not have_css("div.feed-item-container") }
		end

		context "when there is at least one (non sticky)" do
			before do
				post_item.public = true
				post_item.content = "yay!"
				post_item.feed = main_feed
				post_item.save!
				visit root_path
			end
			it_should_behave_like "feed post"
			it { should have_css("div.feed-item-container") }
			it { should_not have_css("div.feed-item-container.sticky") }

			describe "content appears correctly" do
				it { should have_selector("div.text-content", text: post_item.content.html_safe) }
			end

		end

		context "sticky->" do
			before do
					post_item.public = true
					post_item.sticky = true
					post_item.feed = main_feed
					post_item.save!
					visit root_path
			end	
			describe "should have sticky css" do
				it { should have_css("div.feed-item-container.sticky") }
			end
			describe "should be on top" do
				before do
					post_item2 = FactoryGirl.create(:post)
					post_item2.public = true
					post_item2.content = "whatevs"
					post_item2.feed = main_feed
					post_item2.save!
					visit root_path
				end
				it { should have_css("div.feed-item-container", count: 2) }
				it { should have_css("div.feed-item-container.sticky:first-child") }
			end
		end
	end

	describe "videos->" do
		describe "should appear with content on feed" do
			before do
				video_item.public = true
				video_item.title = "i am title of video"
				video_item.for_feedback = false
				video_item.feed_id = main_feed.id
				video_item.public = true
				video_item.save!
				visit root_path
			end
			it { video_item.for_feedback.should eq false }# sanity 
			it_should_behave_like "feed post"
			it { should have_selector("div.video-content > iframe") }
			it { should have_selector("div.video-content > h3", text: video_item.title) }
		end
	end
end	