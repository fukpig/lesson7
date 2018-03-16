module MovieTheater
  module Movies
    # define class  AncientMovie
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
