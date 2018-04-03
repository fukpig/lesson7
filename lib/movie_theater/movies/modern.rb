# define modern movie with release date between 1968..1999
module MovieTheater
  module Movies
    require_relative 'base.rb'
    class Modern < Base
      COST = 3
      PERIOD = :modern

      def poster_title
        "#{title} — modern movie: plays #{actors.join(',')}"
      end
    end
  end
end
