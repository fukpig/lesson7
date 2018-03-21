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
    subject(:pay) { mock_theater.pay(Money.new(1000, "USD")) }

    it 'puts 10 dollars in cashbox' do
      expect{ pay } .to change{mock_theater.cash.cents}.by(1000)
    end
  end

  describe '#take' do
    subject(:take) { mock_theater.take("Bank") }
    before { mock_theater.pay(Money.new(1000, "USD")) }
    it 'take cash by bank get money' do
      expect{ take } .to change{mock_theater.cash.cents}.from(1000).to(0).and(output("Encashment complete\n").to_stdout)
    end

    it 'take cash by noname raise error' do
      expect{mock_theater.take("Noname")}.to raise_error(MovieTheater::Cashbox::InvalidTaker)
    end
  end

end
