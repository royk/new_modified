# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  sender_id   :integer
#  item_id     :integer
#  item_type   :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  action_type :string(255)
#  action_id   :integer
#  public      :boolean
#  read        :boolean          default(FALSE)
#

require 'spec_helper'

describe Notification do
	before(:all)  { User.delete_all }

	let!(:sender) { FactoryGirl.create(:user) }
	let!(:item) { FactoryGirl.create(:video) }

	let!(:notification) { FactoryGirl.create(:notification, sender: sender, item: item) }

	subject { notification }

	context "Validations" do
		it { should be_valid }
		it { should respond_to(:user_id) }
		it { should respond_to(:sender_id) }
		it { should respond_to(:item_id) }
		it { should respond_to(:item_type) }
		it { should respond_to(:action_type) }
		it { should respond_to(:action_id) }
		it { should respond_to(:action) }
		it { should respond_to(:item) }
		it { should respond_to(:user) }
		it { should respond_to(:sender) }
		it { should respond_to(:action_verb) }
		it { should respond_to(:public) }
		it { should respond_to(:read) }

		its(:read) { should==false }
		its(:sender) { should==sender }
	end

	context "invalidates" do
		describe "when there is no item" do
			before do
				notification.item = nil
			end
			it { should_not be_valid }
		end
	end


	context "action verb" do
		describe "when notifying on comment" do
			before :each do
				notification.item = FactoryGirl.create(:comment)
			end
			its(:action_verb) { should== "commented" }
		end
		describe "when notifying on like" do
			before :each do
				notification.item = FactoryGirl.create(:like)
			end
			its(:action_verb) { should=="gave kudos" }
		end
		describe "when action is tag" do
			before :each do
				notification.action_type = "tag"
			end
			its(:action_verb) { should=="tagged you" }
		end
		describe "when notifying on something else" do
			before :each do
				notification.action = nil
			end
			its(:action_verb) { should=="reacted" }
		end
	end

end
