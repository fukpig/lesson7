module MovieTheater
  # define class  AncientMovie
  require_relative 'base_movie.rb'
  class ClassicMovie < BaseMovie
    COST = 1.5
    PERIOD = :classic

    def poster_title
      "#{title} — classic movie, director #{director} #{director_films}"
    end

    private
    def director_films
      count = @movie_collection.movies.select{ |m| m.director == director && m.title != title }.count
      count > 0 ? "(still in the top #{count} of his films)" : ""
    end

  end
end  
