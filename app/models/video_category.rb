# == Schema Information
#
# Table name: video_categories
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  weight                  :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  permalink               :string(255)
#  video_super_category_id :integer
#  description             :string(255)
#

class VideoCategory < ActiveRecord::Base
  attr_accessible :name, :weight, :video_super_category_id, :description
end
