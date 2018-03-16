require_relative '../../spec_helper'
require 'rspec/its'

#wtf?
require 'money'

require_relative '../../../lib/movie_theater/cashbox.rb'
require_relative '../../../lib/movie_theater/theatres/netflix.rb'
require_relative '../../../lib/movie_theater/theatres/theater.rb'

I18n.config.available_locales = :en

describe MovieTheater::Cashbox do
  let(:file) { File.join(File.dirname(__FILE__), "/../../spec_movies.txt") }
  let(:netflix) { MovieTheater::Theatres::Netflix.new(file) }
  let(:theater) { MovieTheater::Theatres::Theater.new(file) }

  describe '#put_in_cash' do
    it 'puts 10 dollars in netflix cashbox' do
      netflix.put_in_cash(Money.new(1000, "USD"))
      expect(netflix.cash).to eq "$10.00"
    end

    it 'puts 10 dollars in netflix cashbox' do
      theater.put_in_cash(Money.new(1000, "USD"))
      expect(theater.cash).to eq "$10.00"
    end
  end

#TO-DO to eq to change by

  describe '#take' do
    it 'take netflix cash by bank' do
      netflix.take("Bank")
      expect(MovieTheater::Theatres::Netflix.cash).to eq "$0.00"
    end

    it 'take theater cash by bank' do
      theater.take("Bank")
      expect(theater.cash).to eq "$0.00"
    end

    it 'take netflix cash by noname' do
      expect{theater.take("Noname")}.to raise_error(MovieTheater::Cashbox::InvalidTaker)
    end

    it 'take theater cash by noname' do
      expect{theater.take("Noname")}.to raise_error(MovieTheater::Cashbox::InvalidTaker)
    end
  end

end
