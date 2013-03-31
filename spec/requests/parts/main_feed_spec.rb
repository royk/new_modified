require 'spec_helper'
describe "main feed" do 
	let(:user) { FactoryGirl.create(:user) }
	let(:post_item) { FactoryGirl.create(:post) }
	let(:video_item) { FactoryGirl.create(:video) }
	let(:blog) { FactoryGirl.create(:blog) }
	let(:blog_post) { FactoryGirl.create(:blog_post, blog: blog) }
	let(:comment) { FactoryGirl.create(:comment) }
	let(:main_feed) { Feed.find_by_name("Main Feed") }

	subject { find("div.front-page-feed") }
	before do 
		sign_in user
		visit root_path 
	end

	shared_examples "feed post" do
		it { should have_selector(".feed-item-container > .feed-item")}
		it { should have_selector(".feed-item-container > .post-footer")}
		it { should have_selector(".feed-item-container > .comment-container")}
	end


	describe "posting form->" do
		it { should have_css("div#feed-form") }
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
			
		end
	end

	context "blog posts->" do
		describe "which are public" do
			before do
				blog_post.public = true
				blog_post.save!
				visit root_path
			end
			describe "should appear on the feed" do
				it { should have_css("div.blog-post-content") }
			end
		end
		describe "which are private," do
			before do
				blog_post.public = false;
				blog_post.save!
				visit root_path
			end
			it "should appear on the feed" do
				page.should have_css("div.blog-post-content") 
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