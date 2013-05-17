# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commenter_id     :integer
#  commentable_id   :integer
#  commentable_type :string(255)      default(""), not null
#  content          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  public           :boolean          default(TRUE)
#  commenter_name   :string(255)
#

class Comment < ActiveRecord::Base
  attr_accessible :content, :commenter, :public, :commenter_name

  acts_as_trashable

  belongs_to :commentable, polymorphic: true
  belongs_to :commenter, 	class_name: "User"
  alias_attribute :user, :commenter
  belongs_to :video
  belongs_to :post
  has_many :notifications, as: :action, dependent: :destroy
  has_many :likes, as: :liked_item

  validates_length_of :content, presence: true, :minimum => 1, maximum: 9999
  #validates :commenter, presence:true
  
  
end
