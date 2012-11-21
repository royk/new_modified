# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  content         :text
#  sender_id       :integer
#  recipient_id    :integer
#  read            :boolean
#  conversation_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Message do
	before(:all)  { User.delete_all }
	let(:sender) { FactoryGirl.create(:user) }
	let(:message) { FactoryGirl.create(:message) }

	subject { message }

	context "Validations" do
		it { should be_valid }
		it { should respond_to(:content) }
		it { should respond_to(:read) }
		it { should respond_to(:recipient) }
		it { should respond_to(:sender) }
		it { should respond_to(:conversation) }
	end

	context "Invalidates" do
		describe "when there's no content" do
			before { message.content = nil }
			it { should_not be_valid }
		end
		describe "when there's empty content" do
			before { message.content = ""}
			it { should_not be_valid}
		end
	end

end
