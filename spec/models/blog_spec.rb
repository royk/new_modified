# == Schema Information
#
# Table name: blogs
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Blog do
  before(:all)  { User.delete_all }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:blog) { FactoryGirl.create(:blog, user: user) }

  subject { blog }

  context "Validations" do
  	it { should be_valid }
  	it { should respond_to(:user_id) }
  	it { should respond_to(:user) }
  	it { should respond_to(:title) }
  	it { should respond_to(:blog_posts) }
  end
end
