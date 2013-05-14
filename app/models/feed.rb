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

  acts_as_trashable

  belongs_to :user
  has_many :posts
  has_many :videos

  validates :name, presence:true, uniqueness: {case_sensitive: false}, length: {maximum: 50, minimum: 2}
  validates :permalink, presence:true, uniqueness: {case_sensitive: false}, length: {maximum: 50, minimum: 2}

  validate :check_permalink

  before_save do |feeds| 
  	self.store_name = self.name.downcase
  end

  def check_permalink
    if /[^a-zA-Z0-9_]/.match(self.permalink)
      self.errors.add(:permalink, "Please use only alphanumeric characters in the URL.")
    end
    forbiddenNames = ["new", "update", "create", "delete", "destroy", "index", "edit"]
    unless self.permalink.nil?
      if forbiddenNames.include? self.permalink.downcase
        self.errors.add(:permalink, "Can't use this URL. Please pick another one.")
      end
    end
  end

  def feed_items(mergeWith = nil)
  	q1 = self.posts.where(sticky:true).order("updated_at DESC")
    if block_given?
  	 q2 = yield self.posts.where(sticky: false)
  	 q3 = yield(self.videos)
     q4 = yield(mergeWith) unless mergeWith==nil
    else
      q2 = self.posts.where(sticky: false)
      q3 = self.videos
      q4 = mergeWith
    end
    if q4==nil
      q5 = q1 + ((q2 + q3).sort_by {|f| -f.updated_at.to_i})
    else
      q5 = q1 + ((q2 + q3 + q4).sort_by {|f| -f.updated_at.to_i})
    end

      
  	return q5
  end

  def permalink
  	if self[:permalink].nil? || self[:permalink].empty?
  		self[:store_name]
  	else
  		self[:permalink]
  	end
  end

end
