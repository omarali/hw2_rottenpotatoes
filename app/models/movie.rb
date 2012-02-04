class Movie < ActiveRecord::Base
  def self.all_ratings
    return Movie.find(:all, :select => 'DISTINCT rating').collect{|x| x.rating}
  end
end
