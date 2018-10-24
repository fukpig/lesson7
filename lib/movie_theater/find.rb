module MovieTheater
  class FindByGenre
    attr_accessor :movies

    def initialize(movies, genres)
      @movies = movies
      genres.each do |genre|
        define_singleton_method :"#{genre.downcase}" do
          movies.select { |movie| movie.genre.include? genre}
        end
      end
    end
  end


  class FindByCountry
    attr_accessor :movies
    def initialize(movies)
      @movies = movies
    end

    def method_missing(m)
      movies.select { |movie| movie.country.downcase == m.to_s.downcase}
    end
  end
end
