# == Schema Information
#
# Table name: likes
#
#  id              :integer          not null, primary key
#  liker_id        :integer
#  liked_item_id   :integer
#  liked_item_type :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Like < ActiveRecord::Base
  attr_accessible :liker, :liked_item

  belongs_to :liked_item, polymorphic: true
  belongs_to :liker, class_name: "User"
  alias_attribute :user, :liker
  belongs_to :video
  belongs_to :post
  has_many :notifications, as: :action, dependent: :destroy

  validates :liked_item_id, presence: true, uniqueness: {scope: [:liker_id, :liked_item_type]}
end
