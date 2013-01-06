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

class Feed < ActiveRecord::Base
  attr_accessible :name, :hidden, :description, :permalink

  belongs_to :user
  has_many :posts
  has_many :videos

  validates :name, presence:true, uniqueness: {case_sensitive: false}, length: {maximum: 50, minimum: 2}
  validates :permalink, presence:true, uniqueness: {case_sensitive: false}, length: {maximum: 50, minimum: 2}

  before_save do |feeds| 
  	self.store_name = self.name.downcase
  end

  def feed_items
  	q1 = self.posts.where(sticky:true).order("updated_at DESC")
  	q2 = yield self.posts.where(sticky: false)
  	q3 = yield(self.videos)
  	q4 = q1 + ((q2 + q3).sort_by {|f| -f.updated_at.to_i})
  	return q4
  end

  def permalink=(value)
  	self[:permalink] = value
  	if self[:permalink].nil? || self[:permalink].empty?
  		self[:permalink] = self.name.clone unless self.name.nil?
  	end
  	self[:permalink].downcase! unless self[:permalink].nil?
  end

  def permalink
  	if self[:permalink].nil? || self[:permalink].empty?
  		self[:store_name]
  	else
  		self[:permalink]
  	end
  end

end
