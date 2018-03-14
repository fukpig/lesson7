module MovieTheater
  # define class  BaseCollection
  class BaseCollection
    include Enumerable

    attr_reader :movies, :genres
    def initialize(movies)
      @movies = movies
      @genres = @movies.flat_map(&:genre).uniq
    end
  end
end
