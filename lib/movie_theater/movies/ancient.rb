# define ancient movie with release date between 1900..1944
module MovieTheater
  module Movies
    require_relative 'base.rb'
    class Ancient < Base
      COST = 1
      PERIOD = :ancient

      def poster_title
        "#{title} — old movie (#{release_year} year)"
      end
    end
  end
end
