class AddForFeedbackToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :for_feedback, :boolean, default: false
  end
end
