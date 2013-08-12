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


end	