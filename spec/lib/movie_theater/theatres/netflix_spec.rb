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
        netflix.define_filter(:the_thing) {  |movie| movie.title.include?('The Thing') }
        netflix.define_filter(:the_thing_with_year) {  |movie, year| movie.title.include?('The Thing') && movie.release_year == year }
        netflix.define_filter(:another_the_thing_with_year, from: :the_thing_with_year, arg: 1982)
        netflix.define_filter(:terminators) {  |movie| movie.title.include?('Terminator') }
        netflix.define_filter(:terminator2) {  |movie, year| movie.title.include?('Terminator') && movie.release_year == year }
        netflix.define_filter(:terminator2_by_year, from: :terminator2, arg: 1991)
        Timecop.freeze(Time.local(2018, 3, 12, 13, 0, 0))
      end
      let (:movie) { double("ClassicMovie", :cost => 1.5, :duration => 100, :title => "The thing", :release_year => 1983) }


      context 'check show' do
        it 'check basic filter' do
          expect{ netflix.show{ |movie| movie.title.include?('The Thing') } }.to output("Now showing: The Thing 13:00 - 14:49\n").to_stdout
        end

        it 'check advanced with defined basic filter' do
          expect{ netflix.show(the_thing: true) }.to output("Now showing: The Thing 13:00 - 14:49\n").to_stdout
        end

        it 'check advanced with defined advanced filter' do
          expect{ netflix.show(the_thing_with_year: 1982) }.to output("Now showing: The Thing 13:00 - 14:49\n").to_stdout
        end

        it 'check advanced with defined advanced filter with parent filter' do
          expect{ netflix.show(another_the_thing_with_year: true) }.to output("Now showing: The Thing 13:00 - 14:49\n").to_stdout
        end

        it 'check combined filter' do
          expect{ netflix.show(genre: 'Action', terminator2: 1991) { |movie| !movie.title.include?('Batman') } }.to output("Now showing: Terminator 2: Judgment Day 13:00 - 15:17\n").to_stdout
        end

        it 'check empty filter' do
          allow(netflix).to receive(:movies).and_return([movie])
          expect{ netflix.show() }.to output("Now showing: The thing 13:00 - 14:40\n").to_stdout
        end

        it 'expect to withdraw payment for movie' do
          expect {netflix.show{ |movie| movie.title.include?('The Thing') }} .to change{netflix.wallet.cents}.from(500).to(200)
        end
      end
    end

    context 'no money on wallet' do
      let (:movie) { double("ClassicMovie", :cost => 1.5, :duration => 100, :title => "The thing") }
      it 'get error' do
        expect{netflix.show{ |movie| movie.title.include?('The Thing') }  }.to raise_error(MovieTheater::Theatres::Netflix::WithdrawError)
      end
    end
  end
end
