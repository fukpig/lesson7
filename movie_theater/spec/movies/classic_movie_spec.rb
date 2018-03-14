require_relative '../spec_helper'
require 'rspec/its'

require_relative '../../theatres/base_theatre.rb'
require_relative '../../movies/classic_movie.rb'

describe MovieTheater::ClassicMovie do
  let(:arguments) { {:href => "http://url.com/", :title => "Vertigo", :release_year => "1958", :country => "USA", :release_date => "1958-10-09", :genre => "Mystery, Thriller", :full_duration_definition => "103 min", :rating => 8.3, :director => "Alfred Hitchcock", :actors => "James Stewart"} }
  let(:theater) { MovieTheater::BaseTheater.new(File.join(File.dirname(__FILE__), "../spec_movies.txt")) }
  let(:movie) { MovieTheater::ClassicMovie.new(arguments, theater.collection) }

  describe 'valid classic movie' do
    subject { movie }

    it 'return classic on get period' do
      expect(movie.period).to eq :classic
    end

    it 'return 1.5 on get cost' do
      expect(movie.cost).to eq 1.5
    end

    it 'valid poster title' do
      expect(movie.poster_title).to eq "Vertigo — classic movie, director Alfred Hitchcock (still in the top 1 of his films)"
    end
  end
end
