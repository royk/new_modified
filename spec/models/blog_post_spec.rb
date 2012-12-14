# == Schema Information
#
# Table name: blog_posts
#
#  id         :integer          not null, primary key
#  blog_id    :integer
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  public     :boolean          default(FALSE)
#

require 'spec_helper'

describe BlogPost do
	before(:all)  { User.delete_all }
	let!(:user) { FactoryGirl.create(:user) }
	let!(:blog) { FactoryGirl.create(:blog) }
	let!(:blog_post) { FactoryGirl.create(:blog_post, blog: blog) }


	subject { blog_post }


	
	context "Validations" do
		it { should be_valid }
		it { should respond_to(:blog) }
		it { should respond_to(:content) }
		it { should respond_to(:comments) }
		it { should respond_to(:likes) }
		it { should respond_to(:notifications) }
		it { should respond_to(:public) }
		it { should respond_to(:notifications) }
	end

	context "invalidates" do
		describe "when blog is empty" do
			before { blog_post.blog = nil }
			it {should_not be_valid}
		end
	end
end
