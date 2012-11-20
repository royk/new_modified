# == Schema Information
#
# Table name: blogs
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Blog < ActiveRecord::Base
  attr_accessible :title

  has_many :blog_posts
  belongs_to :user
  validates :user, presence: true

  def formatted_title
  	user.name + ": " + title
  end
  
end
