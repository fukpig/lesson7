# define new movie with release date > 2000 year
module MovieTheater
  module Movies
    require 'date'
    require_relative 'base.rb'
    class New < Base
      COST = 5
      PERIOD = :new

      def release_years_ago
        Date.today.year - release_year
      end

      def poster_title
        "#{title} — new film, came out #{release_years_ago} years ago!"
      end
    end
  end
end
