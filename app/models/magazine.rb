class Magazine < ActiveRecord::Base
  attr_accessible :end_date, :name, :start_date, :video_ids, :permalink, :year, :date

  def get_year
	  start_date.year
  end

  def get_month
	  start_date.strftime("%m")
  end
end
