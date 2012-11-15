# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commenter_id     :integer
#  commentable_id   :integer
#  commentable_type :string(255)      default(""), not null
#  content          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'spec_helper'

describe Comment do
	before(:all)  { User.delete_all }
	
	let!(:user) { FactoryGirl.create(:user) }

	let!(:video) { FactoryGirl.create(:video) }

	let!(:comment) { video.comments.build(content: "lala", commenter: video.user) }

	subject { comment }

	context "Validations" do
		it { should be_valid }
		it { should respond_to(:content) }
		it { should respond_to(:commenter_id) }
		it { should respond_to(:commentable_id) }
		it { should respond_to(:commentable_type) }
		it { should respond_to(:commenter) }
		its(:commentable) { should==video }
		its(:commenter) { should==video.user }
	end

	context "Invalidates" do
		context "when content" do
			describe "is empty" do
				before { comment.content = nil }
				it { should_not be_valid }
			end

			describe "is too short" do
				before { comment.content = "" }
				it { should_not be_valid }
			end

			describe "is too long" do
				before { comment.content = "a" * 10000 }
				it { should_not be_valid }
			end
		end

		describe "when commenter is empty" do
			before {comment.commenter = nil}
			it {should_not be_valid}
		end

	end

end
