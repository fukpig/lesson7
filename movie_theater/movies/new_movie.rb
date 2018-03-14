module MovieTheater
  # define class  AncientMovie
  require 'date'
  require_relative 'base_movie.rb'
  class NewMovie < BaseMovie
    COST = 5
    PERIOD = :new

    def release_years_ago()
      Date.today.year-release_year
    end

    def poster_title
      "#{title} — new film, came out #{release_years_ago} years ago!"
    end
  end
end
