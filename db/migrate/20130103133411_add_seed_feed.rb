class AddSeedFeed < ActiveRecord::Migration
  def up
  	feed = Feed.create!(name:"Main Feed")
  	(Post.all + Video.where("for_feedback=?", false)).each do |item|
  		item.feed = feed
  		item.save!
  	end

  end

  def down
  	feed = Feed.find_by_name("Main Feed")
  	feed.destroy
  end
end
