# == Schema Information
#
# Table name: feeds
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Feed < ActiveRecord::Base
  attr_accessible :name

  has_many :posts
  has_many :videos

  def feed_items
  	self.posts.where(sticky:true).order("updated_at DESC") + ((yield(self.posts.where(sticky: false)) + yield(self.videos)).sort_by {|f| -f.updated_at.to_i})
  end
  
end
