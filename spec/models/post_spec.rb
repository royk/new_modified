require 'spec_helper'

describe Post do
	let(:user) { FactoryGirl.create(:user) }

	let(:post) { user.posts.build() }

	subject { post }

	it { should be_valid }

	it { should respond_to(:content) }

	describe "validation" do
		before { post.user_id = nil }
		it { should_not be_valid }
	end
end
