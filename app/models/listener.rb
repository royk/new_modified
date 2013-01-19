class Listener < ActiveRecord::Base
  attr_accessible :user, :listened_to, :listened_to_id, :listened_to_type, :user_id

  belongs_to :user
  belongs_to :listened_to, polymorphic: :true

  validates :user, presence: true
  validates :listened_to, presence: true
end
