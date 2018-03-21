module MovieTheater
  module Movies
    # define class  AncientMovie
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
