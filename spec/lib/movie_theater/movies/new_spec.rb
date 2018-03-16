require_relative '../../../spec_helper'
require 'rspec/its'

require_relative '../../../../lib/movie_theater/movies/new.rb'

describe MovieTheater::Movies::New do
  let(:arguments) { {:href => "http://url.com/", :title => "Mad Max: Fury Road", :release_year => "2015", :country => "USA", :release_date => "2015-10-09", :genre => "Action, Adventure, Sci-Fi", :full_duration_definition => "103 min", :rating => 8.1, :director => "George Miller", :actors => "Tom Hardy, Charlize Theron"} }
  let(:movie) { MovieTheater::Movies::New.new(arguments, nil) }

  describe 'valid new movie' do
    subject { movie }

    it 'return classic on get period' do
      expect(movie.period).to eq :new
    end

    it 'return 5 on get cost' do
      expect(movie.cost).to eq 5
    end

    it 'valid poster title' do
      expect(movie.poster_title).to eq "Mad Max: Fury Road — new film, came out 3 years ago!"
    end
  end
end
