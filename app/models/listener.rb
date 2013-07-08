# == Schema Information
#
# Table name: listeners
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  listened_to_id   :integer
#  listened_to_type :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Listener < ActiveRecord::Base
  attr_accessible :user, :listened_to, :listened_to_id, :listened_to_type, :user_id

  belongs_to :user
  belongs_to :listened_to, polymorphic: :true

  validates :user, presence: true
  validates :listened_to, presence: true
end
