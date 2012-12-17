# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  user_id    :integer
#  public     :boolean          default(TRUE)
#  published  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Article < ActiveRecord::Base
  attr_accessible :content, :public, :published, :title

  belongs_to :user

  has_many :comments, as: :commentable, order: 'created_at ASC'
  has_many :likes, as: :liked_item
  
  has_many :notifications, as: :item, dependent: :destroy

  validates :user_id, presence: true
  validates_length_of :content, :minimum => 1, maximum: 9999, presence: true
end
