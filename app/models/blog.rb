# == Schema Information
#
# Table name: blogs
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  featured   :boolean          default(FALSE)
#

class Blog < ActiveRecord::Base
  attr_accessible :title, :featured?

  acts_as_trashable

  has_many :blog_posts, order: 'created_at DESC'
  belongs_to :user
  validates :user, presence: true

  def formatted_title
  	user.shown_name + ": " + title
  end
  
end
