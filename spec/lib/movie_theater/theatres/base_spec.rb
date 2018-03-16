require_relative '../../../spec_helper'
require 'rspec/its'
require 'timecop'

require_relative '../../../../lib/movie_theater/theatres/base.rb'


describe MovieTheater::Theatres::Base do
  let(:file) { File.join(File.dirname(__FILE__), "../../../spec_movies.txt") }
  let(:theater) { MovieTheater::Theatres::Base.new(file) }

  describe '#filter' do
    subject { theater.filter(filter_hash) }
    it 'works with patterns' do
      expect(theater.filter({:title => "Million Dollar Baby"}).first.title).to eq "Million Dollar Baby"
      expect(theater.filter({:release_year => 2019..2020}).first).to be_nil
      expect(theater.filter(director: /Stanley Kubrick/)).to all have_attributes(director: 'Stanley Kubrick')
      expect(theater.filter(period: :classic)).to all have_attributes(period: :classic)
      expect(theater.filter(country: "USA")).to all have_attributes(country: "USA")
      expect(theater.filter(actors: "Clint Eastwood")).to all have_attributes(actors: array_including('Clint Eastwood'))
      expect(theater.filter(genre: 'Drama')).to all have_attributes(genre: array_including('Drama'))
    end
  end

  describe '#show' do
    before { Timecop.freeze(Time.local(2018, 3, 12, 13, 0, 0)) }
    subject { theater.show(movie) }
    let(:movie) { theater.movies.first }
    it 'show movie' do
      expect{theater.show(movie)}.to output("Now showing: The Shining 13:00 - 15:26\n").to_stdout
    end
  end

  describe 'factory' do
    subject { theater }

    it 'check valid classes' do
      expect(theater.movies[0]).to be_a MovieTheater::Movies::Modern
      expect(theater.movies[1]).to be_a MovieTheater::Movies::Ancient
      expect(theater.movies[2]).to be_a MovieTheater::Movies::Classic
      expect(theater.movies[3]).to be_a MovieTheater::Movies::New
    end
  end
end
