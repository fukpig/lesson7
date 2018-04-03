# base theater
module MovieTheater
  module Theatres
    require 'csv'
    require 'money'
    require_relative '../movies/ancient.rb'
    require_relative '../movies/classic.rb'
    require_relative '../movies/modern.rb'
    require_relative '../movies/new.rb'
    require_relative '../movies_collection/base.rb'
    require_relative '../cashbox.rb'

    class Base
      class FileNotFound < ArgumentError
        attr_reader :filename
        def initialize(filename)
          @filename = filename
          super("File #{filename} not found")
        end
      end

      class MovieNotFound < StandardError
        attr_reader :hash
        def initialize(hash)
          @hash = hash.to_s
          super("Movie with params #{hash} not found")
        end
      end

      attr_reader :collection

      MOVIE_HASH_KEYS =
        %i[href title release_year country release_date genre full_duration_definition rating director actors].freeze

      def initialize(filename)
        raise FileNotFound.new, filename unless File.file? filename
        @movies = CSV.read(filename, headers: MOVIE_HASH_KEYS, col_sep: '|').map { |row| create_movie(row.to_hash, self) }
        @collection = MovieTheater::MoviesCollection::BaseCollection.new(@movies)
      end

      def inspect
        "#<MovieCollection movies: #{@collection.movies}>"
      end

      def movies
        @collection.movies
      end

      def filter(filters)
        filters.reduce(movies) { |filtered, (key, value)| filtered.select { |m| m.matches?(key, value) } }
      end

      def show(movie)
        current_time = Time.now.strftime('%H:%M')
        movie_end_time = (Time.now + movie.duration * 60).strftime('%H:%M')
        puts "Now showing: #{movie.title} #{current_time} - #{movie_end_time}"
      end

      private

      def create_movie(movie_hash, theater)
        case movie_hash[:release_year].to_i
        when 1900..1944
          MovieTheater::Movies::Ancient.new(movie_hash, theater)
        when 1945..1967
          MovieTheater::Movies::Classic.new(movie_hash, theater)
        when 1968..1999
          MovieTheater::Movies::Modern.new(movie_hash, theater)
        else
          MovieTheater::Movies::New.new(movie_hash, theater)
        end
      end
    end
  end
end
