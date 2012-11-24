# == Schema Information
#
# Table name: blog_posts
#
#  id         :integer          not null, primary key
#  blog_id    :integer
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  public     :boolean
#

class BlogPost < ActiveRecord::Base
  attr_accessible :content, :public

  belongs_to :blog
  has_one :user, through: :blog

  has_many :comments, as: :commentable, order: 'created_at DESC'
  has_many :likes, as: :liked_item
  has_many :notifications, as: :item, dependent: :destroy

  validates :blog, presence: true

  def content_view
    ret = self.content.bbcode_to_html!({}, true, :enable, :bold).html_safe
    ret = BBCodeizer.bbcodeize(self.content).html_safe
  end

end
