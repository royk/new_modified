# == Schema Information
#
# Table name: videos
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  title      :string(255)
#  vendor     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  uid        :string(255)
#  url        :string(255)
#  public     :boolean          default(TRUE)
#  location   :string(255)
#  maker      :string(255)
#  players    :text
#

class Video < ActiveRecord::Base
  attr_accessible :title, :vendor, :uid, :url, :public, :location, :maker, :players

  belongs_to :user

  serialize :players

  has_many :comments, as: :commentable, order: 'created_at ASC'
  has_many :likes, as: :liked_item
  has_many :notifications, as: :item, dependent: :destroy

  validates :user_id, presence: true
  validates :uid, presence: true, uniqueness: { case_sensitive: true }
  validates :vendor, presence: true

  default_scope order: 'videos.created_at DESC'
end
