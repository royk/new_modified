# == Schema Information
#
# Table name: feeds
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  store_name  :string(255)
#  hidden      :boolean          default(FALSE)
#  user_id     :integer
#  permalink   :string(255)
#  description :text
#

require 'spec_helper'

describe Feed do
	let(:feed) { FactoryGirl.create(:feed) }

	subject { feed }

	context "Name validations" do
		describe "shouldn't allow dot in permalink" do
			before { feed.permalink = "lala.foo" }
			it { should_not be_valid }
		end
		context "forbid crud permalink" do
			describe "new" do
				before { feed.permalink = "new" }
				it { should_not be_valid }
			end
		end
	end

end
