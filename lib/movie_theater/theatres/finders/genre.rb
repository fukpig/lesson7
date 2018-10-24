module MovieTheater
  module Theatres
    module Finders
      class GenreFinder
        def initialize(theater)
          @theater = theater

          @theater.collection.movies.each do |movie|
            movie.genre.each do |genre|
              genre = genre.downcase
              if !self.respond_to? genre
                #TO-DO ASK ABOUT METHOD AS ARGUMENT NOT THEATER OBJECT
                self.class.send(:define_method, genre) { @theater.filter({:genre => genre}) }
              end
            end
          end
        end

      end
    end
  end
end
