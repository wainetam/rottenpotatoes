class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :release_date, :commit # WT added to make attributes accessible
  end