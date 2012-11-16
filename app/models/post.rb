# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Post < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user
  has_many :comments, as: :commentable, order: 'created_at DESC'
  
  validates :user_id, presence: true
  validates_length_of :content, :minimum => 1, maximum: 9999, presence: true

  default_scope order: 'posts.created_at DESC'
end
