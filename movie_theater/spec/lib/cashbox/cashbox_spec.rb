require_relative '../../spec_helper'
require 'rspec/its'

require_relative '../../../lib/cashbox/cashbox.rb'
require_relative '../../../theatres/netflix.rb'
require_relative '../../../theatres/theater.rb'

I18n.config.available_locales = :en

describe MovieTheater::Cashbox do
  let(:file) { File.join(File.dirname(__FILE__), "/../../spec_movies.txt") }
  let(:netflix) { MovieTheater::Netflix.new(file) }
  let(:theater) { MovieTheater::Theater.new(file) }

  describe '#put_in_cash' do
    it 'puts 10 dollars in netflix cashbox' do
      netflix.put_in_cash(Money.new(10, "USD"))
      expect(netflix.cash).to eq "$10.00"
    end

    it 'puts 10 dollars in netflix cashbox' do
      theater.put_in_cash(Money.new(10, "USD"))
      expect(theater.cash).to eq "$10.00"
    end
  end

  describe '#take' do
    it 'take netflix cash by bank' do
      netflix.take("Bank")
      expect(netflix.cash).to eq "$0.00"
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
