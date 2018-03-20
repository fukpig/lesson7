require_relative '../../spec_helper'
require 'rspec/its'
require 'money'

require_relative '../../../lib/movie_theater/cashbox.rb'
require_relative '../../../lib/movie_theater/theatres/netflix.rb'
require_relative '../../../lib/movie_theater/theatres/theater.rb'

I18n.config.available_locales = :en

describe MovieTheater::Cashbox do
  let(:mock_theater) { klass.new }
  let(:klass) do
    Class.new do
      include MovieTheater::Cashbox
    end
  end

  describe '#put_in_cash' do
    it 'puts 10 dollars in cashbox' do
      mock_theater.put_in_cash(Money.new(1000, "USD"))
      expect(mock_theater.get_money_in_cashbox).to eq "$10.00"
    end
  end

  describe '#take' do
    it 'take cash by bank get money' do
      mock_theater.take_money_from_cashbox("Bank")
      expect(mock_theater.get_money_in_cashbox).to eq "$0.00"
    end

    it 'take cash by noname raise error' do
      expect{mock_theater.take_money_from_cashbox("Noname")}.to raise_error(MovieTheater::Cashbox::InvalidTaker)
    end

    it 'take cash by bank get output' do
      expect{mock_theater.take_money_from_cashbox("Bank")}.to output("Encashment complete\n").to_stdout
    end
  end

end
