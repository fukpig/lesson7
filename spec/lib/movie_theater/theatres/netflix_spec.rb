require_relative '../../../spec_helper'
require 'rspec/its'
require 'timecop'

require_relative '../../../../lib/movie_theater/theatres/netflix.rb'

I18n.config.available_locales = :en


describe MovieTheater::Theatres::Netflix do
  let(:file) { File.join(File.dirname(__FILE__), "../../../spec_movies.txt") }
  let(:netflix) { MovieTheater::Theatres::Netflix.new(file) }

  before { MovieTheater::Theatres::Netflix.clean() }

  describe '#pay' do
    subject(:pay) { netflix.pay(5) }

    it 'get 5 dollars in cashbox after payment' do
      expect { pay } .to change{MovieTheater::Theatres::Netflix.cash.cents}.by(500)
    end

    context 'get 5 dollars in wallet after payment' do
      it { expect { pay } .to change(netflix, :wallet).by(Money.new(500, "USD")) }
    end
  end

  describe '#withdraw' do
    subject(:withdraw) { netflix.withdraw(5) }
    context 'when enough money' do
      before { netflix.pay(5) }
      it { expect { withdraw } .to change{netflix.wallet.cents}.by(-500) }
    end
    context 'when not enough money' do
      it { expect { withdraw } .to raise_error(MovieTheater::Theatres::Netflix::WithdrawError) }
    end
  end

  describe '#check_money' do
    subject(:check_money) { netflix.check_money(Money.new(500, "USD")) }
    context 'when enough money' do
      before { netflix.pay(5) }
      it { expect { check_money } .to_not raise_error }
    end
    context 'when not enough money' do
      it { expect { check_money } .to raise_error(MovieTheater::Theatres::Netflix::WithdrawError) }
    end
  end

  describe '#how_much?' do
    it 'return 3 dollars' do
      expect(netflix.how_much?("The Shining")).to eq 3
    end
  end

  
  describe '#show' do
    context 'check show' do
      before do
        netflix.pay(5)
        netflix.define_filter(:the_thing) {  |movie| movie.title.include?('The thing') }
        netflix.define_filter(:the_thing_with_year) {  |movie, year| movie.title.include?('The thing') && movie.release_year == year }
        netflix.define_filter(:another_the_thing_with_year, from: :the_thing_with_year, arg: 1983)
      end
      before { Timecop.freeze(Time.local(2018, 3, 12, 13, 0, 0)) }
      let (:movie) { double("ClassicMovie", :cost => 1.5, :duration => 100, :title => "The thing", :release_year => 1983) }


      context 'check show' do
        it 'check basic filter' do
          allow(netflix).to receive(:movies).and_return([movie])
          expect{ netflix.show{ |movie| movie.title.include?('The thing') } }.to output("Now showing: The thing 13:00 - 14:40\n").to_stdout
        end

        it 'check advanced with defined basic filter' do
          allow(netflix).to receive(:movies).and_return([movie])
          expect{ netflix.show(the_thing: true) }.to output("Now showing: The thing 13:00 - 14:40\n").to_stdout
        end

        it 'check advanced with defined advanced filter' do
          allow(netflix).to receive(:movies).and_return([movie])
          expect{ netflix.show(the_thing_with_year: 1983) }.to output("Now showing: The thing 13:00 - 14:40\n").to_stdout
        end

        it 'check advanced with defined advanced filter with parent filter' do
          allow(netflix).to receive(:movies).and_return([movie])
          expect{ netflix.show(another_the_thing_with_year: true) }.to output("Now showing: The thing 13:00 - 14:40\n").to_stdout
        end

        it 'expect to withdraw payment for movie' do
          allow(netflix).to receive(:movies).and_return([movie])
          expect {netflix.show{ |movie| movie.title.include?('The thing') }} .to change{netflix.wallet.cents}.from(500).to(350)
        end
      end
    end

    context 'no money on wallet' do
      let (:movie) { double("ClassicMovie", :cost => 1.5, :duration => 100, :title => "The thing") }
      it 'get error' do
        allow(netflix).to receive(:movies).and_return([movie])
        expect{netflix.show{ |movie| movie.title.include?('thing') }  }.to raise_error(MovieTheater::Theatres::Netflix::WithdrawError)
      end
    end
  end
end
