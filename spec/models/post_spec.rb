# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  public     :boolean          default(TRUE)
#

require 'spec_helper'

describe Post do
	before(:all)  { User.delete_all }
	
	let!(:user) { FactoryGirl.create(:user) }

	let!(:post) { user.posts.build(content: "lala") }

	subject { post }

	it { should be_valid }

	it { should respond_to(:content) }

	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	its(:user) { should==user } 

	describe "Validations" do
		context "without user id" do
			before { post.user_id = nil }
			it { should_not be_valid }
		end
		context "without content" do
			before { post.content = nil}
			it { should_not be_valid}
		end
		context "with empty content" do
			before { post.content = "" }
			it { should_not be_valid }
		end
		context "with too long a content" do
			before { post.content = "a" * 10000 }
			it { should_not be_valid }
		end
	end


end
