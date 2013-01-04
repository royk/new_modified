# == Schema Information
#
# Table name: feeds
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  store_name :string(255)
#  hidden     :boolean          default(FALSE)
#  user_id    :integer
#

class Feed < ActiveRecord::Base
  attr_accessible :name, :hidden

  belongs_to :user
  has_many :posts
  has_many :videos

  validates :name, presence:true, uniqueness: {case_sensitive: false}, length: {maximum: 50, minimum: 2}
  before_save {|feeds| self.store_name = self.name.downcase }

  def feed_items
  	self.posts.where(sticky:true).order("updated_at DESC") + ((yield(self.posts.where(sticky: false)) + yield(self.videos)).sort_by {|f| -f.updated_at.to_i})
  end
  
end
