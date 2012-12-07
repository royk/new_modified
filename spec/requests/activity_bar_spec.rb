require 'spec_helper'
describe "activity bar" do 
	let(:user) { FactoryGirl.create(:user) }
	let(:post_item) { FactoryGirl.create(:post) }
	let(:comment) { FactoryGirl.create(:comment) }

	subject { find("ul.activities") }

	describe "when there are no activities" do
		before { visit root_path }
		it { should_not have_css("li") }
	end

	describe "when there's an activity notification" do
		before :each do
			notification = Notification.new
			notification.item = post_item
			notification.sender = user
			notification.action = comment
			notification.public = true
			notification.save!
			visit root_path
		end
		it { should have_css("li", count: 1) }
		it { should have_link(user.shown_name, href: user_path(user)) }
		it { should have_link(post_item.class.to_s.downcase, href: post_path(post_item)) }
	end
end