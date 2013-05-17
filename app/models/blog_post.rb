# == Schema Information
#
# Table name: blog_posts
#
#  id         :integer          not null, primary key
#  blog_id    :integer
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  public     :boolean          default(FALSE)
#

class BlogPost < ActiveRecord::Base

  attr_accessible :content, :public, :created_at

  acts_as_trashable

  searchable do
	  text :content
	  text :user do
		  user.shown_name unless user.nil?
	  end
	  text :comments do
		  comments.map { |comment| comment.content }
	  end
	  time :created_at
  end

  belongs_to :blog
  has_one :user, through: :blog

  has_many :comments, as: :commentable, order: 'created_at ASC'
  has_many :listeners, as: :listened_to, dependent: :destroy
  has_many :likes, as: :liked_item
  has_many :notifications, as: :item, dependent: :destroy

  validates :blog, presence: true
  validates :content, presence: true


 

end
