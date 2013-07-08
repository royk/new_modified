# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  email            :string(255)
#  remember_token   :string(255)
#  password_digest  :string(255)
#  admin            :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  gravatar_suffix  :string(255)
#  nickname         :string(255)
#  reset_code       :string(255)
#  country          :string(255)
#  city             :string(255)
#  modified_user    :string(255)
#  author           :boolean          default(FALSE)
#  birthday         :datetime
#  started_playing  :datetime
#  bap              :boolean          default(FALSE)
#  bap_name         :string(255)
#  bap_induction    :datetime
#  motto            :string(255)
#  hobbies          :text
#  privacy_settings :integer          default(0)
#  latitude         :float
#  longitude        :float
#  last_visit       :datetime
#  about_title      :string(255)
#  about_content    :text
#  registered       :boolean          default(TRUE)
#  website          :string(255)
#  last_online      :datetime
#

class User < ActiveRecord::Base
	require 'yaml'
	attr_accessible :email, :name, :password, :password_confirmation, :gravatar_suffix,
					:nickname, :blog_title, :reset_code, :country, :city, :modified_user,
					:birthday, :started_playing, :bap, :bap_name, :bap_induction,
					:motto, :hobbies, :last_visit, :about_title, :about_content, :registered, :website,
					:last_online, :created_at

	searchable do
		text :nickname
		text :name
		time :created_at
	end

	acts_as_trashable

	#bitmask :privacy_settings, as: [:expose_name, :expose_location], zero_value: :none

	geocoded_by :location

	has_secure_password

	before_save { |user| user.email = email.downcase }
	before_save :recreate_remember_token

	has_many :posts, dependent: :destroy

	has_many :feeds

	has_many :articles

	has_many :achievements
	has_many :training_sessions

	has_many :videos
	has_and_belongs_to_many :appears_in_videos, class_name: "Video", uniq: true

	has_many :attendances, class_name: "Attendant"
	has_and_belongs_to_many :results

	has_many :notifications, dependent: :destroy
	has_many :notifications, dependent: :destroy, foreign_key: "sender_id"
	has_many :notifications, dependent: :destroy, foreign_key: "item_id"

	has_many :comments, dependent: :destroy, foreign_key: "commenter_id"
	has_many :listeners, as: :listened_to, dependent: :destroy
	has_many :likes, dependent: :destroy, foreign_key: "liker_id"

	has_many :sent_messages, class_name: "Message", foreign_key: "sender_id"
	has_many :received_messages, class_name: "Message", foreign_key: "recipient_id"

	has_one :blog

	validates :name, presence: true, length: {maximum: 50, minimum: 4}
	validates :nickname, length: {maximum: 50, minimum: 3}, allow_blank: true, uniqueness: {case_sensitive: false}
	EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: {with: EMAIL_REGEX}, uniqueness: {case_sensitive: false}

	validates :modified_user, allow_blank: true, uniqueness: {case_sensitive: true}

	validates :password, presence: true, length: {minimum: 6}, :if => :validate_password?
	validates :password_confirmation, presence: true, :if => :validate_password?

	before_destroy :destroy_notifications, :destroy_comments, :destroy_video_assoc

	after_validation :geocode  # fill in longitude and latitude

	@reset_remember_token = true

	class USER_DATA
		def initialize(user_name, articles, blog, posts)
			@user_name = user_name
			@articles = articles
			if blog.nil?
				@blog_posts = nil
			else
				@blog_posts = blog.blog_posts
			end
			@posts = posts
		end
	end

	def self.online_now
		where("last_online > ?", 5.minutes.ago)
	end

	def export_to_csv
		user_data = USER_DATA.new(self.name, self.articles, self.blog, self.posts)
		YAML::dump(user_data)
	end

	def unread_notifications
		all_unread = notifications.where(read: false)
		{	"texts"=>all_unread.where("item_type != ?", "Like"),
			"likes"=>all_unread.where("item_type = ?", "Like")}
	end

	def shown_name
		nickname.blank? ? name : nickname
	end

	def blog_title
		blog.title if !blog.nil?
	end

	def blog_title=(value)
		if !blog.nil?
			blog.title = value
			blog.save
		end
	end
	def gravatar_email
		if gravatar_suffix.nil? || gravatar_suffix.empty?
			email
		else
			parts = email_parts
			return parts[0] + "+" + gravatar_suffix + "@" + parts[1]
		end
	end

	def highest_role
		if admin
			"Admin"
		elsif author
			"Author"
		end
	end

	def email_parts
		email.split("@")
	end

	def notifications
		Notification.where("user_id = ?", id).order("created_at DESC")
	end

	def create_reset_code
		self.attributes = {:reset_code => Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )}
		self.save()
		self.reset_code
	end

	def location
		[city, country].compact.join(", ")
	end

	def age
		unless birthday.nil?
			years_diff birthday
		else
			0
		end
	end

	def years_playing
		unless started_playing.nil?
			years_diff started_playing
		else
			0
		end
	end

	def events_participation
		self.attendances + self.results
	end

	def save_without_signout
		@reset_remember_token = false
		result = self.save()
		@reset_remember_token = true
		return result
	end

	private
	def years_diff(date)
		now = Time.now.utc.to_date
		now.year - date.year - ((now.month > date.month || (now.month == date.month && now.day >= date.day)) ? 0 : 1)
	end

	def recreate_remember_token
		if remember_token==nil? || @reset_remember_token.nil? || @reset_remember_token
			create_remember_token
		end
	end

	def create_remember_token
		self.remember_token = SecureRandom.urlsafe_base64
	end

	def validate_password?
		password.present? || password_confirmation.present?
	end

	def destroy_notifications
		Notification.find_all_by_sender_id(self).each {|n| n.destroy}
	end

	def destroy_comments
		Comment.find_all_by_commenter_id(self).each {|n| n.destroy}
	end

	def destroy_video_assoc
		appears_in_videos.each do |video|
			video.move_to_named_players self
		end
	end
end

