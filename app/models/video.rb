# == Schema Information
#
# Table name: videos
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  title        :string(255)
#  vendor       :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  uid          :string(255)
#  url          :string(255)
#  public       :boolean          default(TRUE)
#  location     :string(255)
#  maker        :string(255)
#  players      :text
#  for_feedback :boolean          default(FALSE)
#  feed_id      :integer
#

class Video < ActiveRecord::Base

  def Video.move_to_user_players(user)
    Video.all.each do |video|
      if video.players && video.players.include?(user.name)
        video.record_timestamps = false
        video.players.delete(user.name)
        video.user_players ||= []
        video.user_players << user
        video.save
        video.record_timestamps = true
      end
    end
  end

  attr_accessible :created_at, :title, :vendor, :uid, :url, :public, :location, :maker, :players, :for_feedback, :feed_id
  acts_as_taggable
  acts_as_trashable

  searchable do
	  text :title
	  text :comments do
		  comments.map { |comment| comment.content }
	  end
	  text :players_names do
		  players_names.map { |name| name }
	  end
	  time :created_at
  end

  belongs_to :user
  belongs_to :feed

  serialize :players

  has_many :comments, as: :commentable, order: 'created_at ASC'
  has_many :listeners, as: :listened_to, dependent: :destroy
  has_many :likes, as: :liked_item
  has_many :notifications, as: :item, dependent: :destroy

  has_and_belongs_to_many :user_players, class_name: "User", uniq: true

  has_one :result

  validates :uid, presence: true, uniqueness: { case_sensitive: true }
  validates :vendor, presence: true

  default_scope order: 'videos.created_at DESC'

  def name_for_notification
    if for_feedback
      "feedback video"
    else
      "video"
    end
  end

  def players_names
    names = []
    players_list.each do |player|
      if player.class==String
        names << player
      else
        names << player.name
      end
    end
    return names
  end

  def players_list
    ((user_players||[]) + (players||[]))
  end

  def remove_players
    self.tag_list ||= []
    players_list.each do |p|
      if p.class==String
        players.delete(p)
        self.tag_list = self.tag_list - p.split
      else
        user_players.delete(p)
        p.appears_in_videos.delete(self)
        self.tag_list = self.tag_list - p.name.split
      end
    end
  end

  def add_player(name)
    self.players ||= []
    unless players_names.include? name
      self.tag_list ||= []
      self.tag_list = self.tag_list + name.split
      player = User.where('lower(name) = ?', name.downcase).first
      unless player.nil?
        player = player
        user_players << player
        player.appears_in_videos << self
        return player
      else
        self.players << name
        return nil
      end
    end
  end

  def move_to_named_players(user)

    if self.user_players && self.user_players.include?(user)
      self.record_timestamps = false
      user_players.delete(user)
      self.players ||= []
      self.players << user.name
      self.save
      self.record_timestamps = true
    end
  end
end
