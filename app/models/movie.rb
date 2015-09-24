class Movie < ActiveRecord::Base
     def self.all_ratings
	self.select(:rating).uniq.map{|movie| movie.rating}.sort
     end
end

