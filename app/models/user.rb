# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  remember_token  :string(255)
#  admin           :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  gravatar_suffix :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :gravatar_suffix
  has_secure_password

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  has_many :posts, dependent: :destroy

  has_many :videos

  validates :name, presence: true, length: {maximum: 50}
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  validates :password, presence: true, length: {minimum: 6}
  validates :password_confirmation, presence: true

  def gravatar_email
    if gravatar_suffix.nil? || gravatar_suffix.empty?
      email
    else
      parts = email_parts
      return parts[0] + "+" + gravatar_suffix + "@" + parts[1]
    end
  end

  def email_parts
    email.split("@")
  end

  def feed
    (Post.all + Video.all).sort_by {|f| -f.created_at.to_i} # sort by descending by converting to int and negating
  end

  private
  	def create_remember_token
  		self.remember_token = SecureRandom.urlsafe_base64
  	end
end
