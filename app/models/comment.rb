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
#

class Comment < ActiveRecord::Base
  attr_accessible :content, :commenter, :public

  belongs_to :commentable, polymorphic: true
  belongs_to :commenter, 	class_name: "User"
  belongs_to :video
  belongs_to :post

  validates_length_of :content, presence: true, :minimum => 1, maximum: 9999
  validates :commenter, presence:true
  
end
