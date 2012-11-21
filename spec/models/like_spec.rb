# == Schema Information
#
# Table name: likes
#
#  id              :integer          not null, primary key
#  liker_id        :integer
#  liked_item_id   :integer
#  liked_item_type :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Like do
	before(:all)  { User.delete_all }

	let!(:like) { FactoryGirl.create(:like) }

	subject { like }

	context "Validations" do
		it { should be_valid }
		it { should respond_to(:liker) }
		it { should respond_to(:liked_item) }
		it { should respond_to(:video) }
		it { should respond_to(:post) }
	end

	context "Liked item" do
		it "can be video" do
			video = FactoryGirl.create(:video)
			like2 = video.likes.build()

			like2.liked_item.should eq(video)
		end
		it "can be post" do
			post = FactoryGirl.create(:post)
			like2 = post.likes.build()

			like2.liked_item.should eq(post)
		end
	end

end

