# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Post do
	let!(:user) { FactoryGirl.create(:user) }

	let!(:post) { user.posts.build(content: "lala") }

	subject { post }

	it { should be_valid }

	it { should respond_to(:content) }

	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	its(:user) { should==user } 

	


	describe "validation" do
		before { post.user_id = nil }
		it { should_not be_valid }
	end

end
