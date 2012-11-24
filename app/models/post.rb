# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  public     :boolean          default(TRUE)
#

class Post < ActiveRecord::Base
  attr_accessible :content, :public

  belongs_to :user
  has_many :comments, as: :commentable, order: 'created_at DESC'
  has_many :likes, as: :liked_item
  has_many :notifications, as: :item, dependent: :destroy
  
  validates :user_id, presence: true
  validates_length_of :content, :minimum => 1, maximum: 9999, presence: true

  default_scope order: 'posts.created_at DESC'
end
