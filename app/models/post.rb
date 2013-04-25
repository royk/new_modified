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
#  sticky     :boolean          default(FALSE)
#  feed_id    :integer
#

class Post < ActiveRecord::Base
  attr_accessible :created_at, :content, :public, :sticky, :feed_id

  belongs_to :user
  belongs_to :feed
  has_many :comments, as: :commentable, order: 'created_at ASC'
  has_many :likes, as: :liked_item
  has_many :notifications, as: :item, dependent: :destroy
  has_many :listeners, as: :listened_to, dependent: :destroy
  
  validates :user_id, presence: true
  validates_length_of :content, :minimum => 1, maximum: 9999, presence: true

  default_scope order: 'posts.created_at DESC'

	searchable do
		text :content
		text :comments do
			comments.map { |comment| comment.content }
		end
		text :user do
			user.shown_name unless user.nil?
		end
		time :created_at
	end

  
end
