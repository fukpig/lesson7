module MovieTheater
  # define class  AncientMovie
  require_relative 'base_movie.rb'
  class ModernMovie < BaseMovie
    COST = 3
    PERIOD = :modern

    def poster_title
      "#{title} — modern movie: plays #{actors.join(',')}"
    end
  end
end  
