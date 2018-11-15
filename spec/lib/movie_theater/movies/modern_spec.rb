require_relative '../../../spec_helper'
require 'rspec/its'

require_relative '../../../../lib/movie_theater/movies/modern.rb'

describe MovieTheater::Movies::Modern do
  let(:arguments) { {:href => "http://url.com/", :title => "The Shining", :release_year => "1980", :country => "USA", :release_date => "1980-10-09", :genre => "Drama, Horror", :full_duration_definition => "103 min", :rating => 8.5, :director => "Stanley Kubrick", :actors => "Jack Nicholson, Ron Swanson"} }
  let(:movie) { MovieTheater::Movies::Modern.new(arguments) }

  describe 'valid modern movie' do
    subject { movie }

    it 'return modern on get period' do
      expect(movie.period).to eq :modern
    end

    it 'return 3 on get cost' do
      expect(movie.cost).to eq 3
    end

    it 'valid poster title' do
      expect(movie.poster_title).to eq "The Shining — modern movie: plays Jack Nicholson, Ron Swanson"
    end
  end
end
