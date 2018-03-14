module MovieTheater
# define class  AncientMovie
  require_relative 'base_movie.rb'
  class AncientMovie < BaseMovie
    COST = 1
    PERIOD = :ancient

    def poster_title
      "#{title} — old movie (#{release_year} year)"
    end
  end
end  
