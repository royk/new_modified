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
  acts_as_taggable

  belongs_to :user

  serialize :players

  has_many :comments, as: :commentable, order: 'created_at ASC'
  has_many :likes, as: :liked_item
  has_many :notifications, as: :item, dependent: :destroy
  has_and_belongs_to_many :user_players, class_name: "User", uniq: true

  validates :user_id, presence: true
  validates :uid, presence: true, uniqueness: { case_sensitive: true }
  validates :vendor, presence: true

  default_scope order: 'videos.created_at DESC'

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
    tag_list ||= []
    players_list.each do |p|
      if p.class==String
        players.delete(p)
        tag_list = tag_list - p.split
      else
        user_players.delete(p)
        p.appears_in_videos.delete(self)
        tag_list = tag_list - p.name.split
      end
    end
  end

  def add_player(name)
    self.players ||= []
    unless players_names.include? name
      tag_list ||= []
      tag_list = tag_list + name.split
      player = User.where('lower(name) = ?', name.downcase).first
      unless player.nil?
        player = player
        user_players << player
        player.appears_in_videos << self
        logger.debug "1Adding #{player.name}"
        return player
      else
        self.players << name
        logger.debug "2Adding #{name}"
        return nil
      end
    end
    
  end
end
