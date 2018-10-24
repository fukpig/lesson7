require_relative '../../../spec_helper'
require 'rspec/its'

require_relative '../../../../lib/movie_theater/movies/base.rb'


describe MovieTheater::Movies::Base do
  let(:arguments) { {:href => "url", :title => "The thing", :release_year => "1983", :country => "USA", :release_date => "1983-01-01", :genre => "Horror", :full_duration_definition => "103 min", :rating => 8, :director => 'Carpenter', :actors => "Kurt Russell"} }
  let(:movie) { MovieTheater::Movies::Base.new(arguments) }

  describe 'valid new object' do
    subject { movie }

    it {
      is_expected.to have_attributes(
        genre: ["Horror"],
        release_year: 1983,
        duration: 103,
        duration_definition: "min",
        rating: 8.0,
        actors: ["Kurt Russell"]
      )
    }

    it 'return error on get cost' do
      expect{movie.cost}.to raise_error(MovieTheater::Movies::Base::ConstantError)
    end

    it 'return error on get period' do
      expect{movie.period}.to raise_error(MovieTheater::Movies::Base::ConstantError)
    end
  end

  describe '#matches?' do
    subject { movie.matches?(filter, value) }

    context 'release_year' do
      let(:filter) { :release_year }
      context 'when matches' do
        let(:value) { 1983 }
        it { is_expected.to be_truthy }
      end
      context 'when not matches' do
        let(:value) { 2010 }
        it { is_expected.to be_falsy }
      end
      context 'when range matches' do
        let(:value) { 1980..2010 }
        it { is_expected.to be_truthy }
      end
      context 'when range not matches' do
        let(:value) { 2005..2010 }
        it { is_expected.to be_falsy }
      end
    end

    it 'works with simple values' do
      expect(movie.matches?(:release_year, 1983)).to be_truthy
      expect(movie.matches?(:release_year, 2010)).to be_falsy
      expect(movie.matches?(:title, 'The thing')).to be_truthy
      expect(movie.matches?(:title, 'Mad max')).to be_falsy
    end

    it 'works with patterns' do
      expect(movie.matches?(:release_year, 1980..1990)).to be_truthy
      expect(movie.matches?(:release_year, 1990..2000)).to be_falsy
      expect(movie.matches?(:title, /thing/i)).to be_truthy
      expect(movie.matches?(:title, /mad/i)).to be_falsy
    end
  end

  describe '#matches_all?' do
    subject { movie.matches_all?(filter) }

    it 'works with simple values' do
      expect(movie.matches_all?({:release_year=>1983})).to be_truthy
      expect(movie.matches_all?({:release_year=>2010})).to be_falsy
      expect(movie.matches_all?({:genre=>'Horror'})).to be_truthy
      expect(movie.matches_all?({:genre=>'Drama'})).to be_falsy
    end
  end

end
