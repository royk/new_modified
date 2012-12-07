require 'spec_helper'
describe "main feed" do 
	let(:user) { FactoryGirl.create(:user) }
	let(:post_item) { FactoryGirl.create(:post) }
	let(:comment) { FactoryGirl.create(:comment) }

	subject { find("div.front-page-feed") }
	before { visit root_path }

	context "posting form->" do
		describe "when logged out" do
			it { should_not have_css("div#feed-form") }
		end

		describe "when signed in" do
			before do
				sign_in user
				visit root_path
			end
			it { should have_css("div#feed-form") }
		end
	end

	context "posts->" do
		describe "when there aren't any" do
			it { should_not have_css("div.feed-item-container") }
		end

		describe "when there is at least one (non sticky)" do
			before do
				post_item.public = true
				post_item.save!
				visit root_path
			end
			it { should have_css("div.feed-item-container") }
			it { should_not have_css("div.feed-item-container.sticky") }
		end

		context "sticky->" do
			before do
					post_item.public = true
					post_item.sticky = true
					post_item.save!
					visit root_path
			end	
			describe "should have sticky css" do
				it { should have_css("div.feed-item-container.sticky") }
			end
			describe "should be on top" do
				before do
					video = FactoryGirl.create(:video)
					video.public = true
					video.uid = "abc"
					video.save!
					visit root_path
				end
				it { should have_css("div.feed-item-container", count: 2) }
				it { should have_css("div.feed-item-container.sticky:first-child") }
			end
		end
	end
end	