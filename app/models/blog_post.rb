# == Schema Information
#
# Table name: blog_posts
#
#  id         :integer          not null, primary key
#  blog_id    :integer
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  public     :boolean
#

class BlogPost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :blog

  has_many :comments, as: :commentable, order: 'created_at DESC'
  has_many :likes, as: :liked_item
  has_many :notifications, as: :item, dependent: :destroy

  validates :blog, presence: true

  def public=(value)
  	if correct_user?(current_user)
  		self[:public] = value
  	end
  end

  
end
