require_relative '../spec_helper'
require 'rspec/its'
require 'timecop'

require_relative '../../theatres/netflix.rb'

I18n.config.available_locales = :en


describe MovieTheater::Netflix do
  let(:file) { File.join(File.dirname(__FILE__), "../spec_movies.txt") }
  let(:netflix) { MovieTheater::Netflix.new(file) }

  describe '#pay' do
    subject(:pay) { netflix.pay(5) }

    it 'get 10 dollars in cashbox after payment' do
      netflix.pay(10)
      expect(netflix.cash).to eq "$10.00"
    end

    context 'get 5 dollars in wallet after payment' do
      it { expect { pay } .to change(netflix, :wallet).by(5) }
    end
  end

  describe '#cash' do
    it 'get 25 dollars in cashbox after payment' do
      netflix.pay(15)
      expect(netflix.cash).to eq "$30.00"
    end
  end

  describe '#add_to_cash' do
    it 'get 5 dollars in cashbox' do
      netflix.add_to_cash(5)
      expect(netflix.cash).to eq "$35.00"
    end
  end

  describe '#withdraw' do
    subject(:withdraw) { netflix.withdraw(5) }
    context 'when enough money' do
      before { netflix.pay(5) }
      it { expect { withdraw } .to change(netflix, :wallet).by(-5) }
    end
    context 'when not enough money' do
      it { expect { withdraw } .to raise_error(MovieTheater::Netflix::WithdrawError) }
    end
  end

  describe '#check_money' do
    subject(:check_money) { netflix.check_money(5) }
    context 'when enough money' do
      before { netflix.pay(5) }
      it { expect { check_money } .to_not raise_error }
    end
    context 'when not enough money' do
      it { expect { check_money } .to raise_error(MovieTheater::Netflix::WithdrawError) }
    end
  end

  describe '#how_much?' do
    it 'return 3 dollars' do
      expect(netflix.how_much?("The Shining")).to eq 3
    end
  end

  describe '#show' do
    context 'check show' do
      before { netflix.pay(5) }
      before { Timecop.freeze(Time.local(2018, 3, 12, 13, 0, 0)) }
      let (:movie) { double("ClassicMovie", :cost => 1.5, :duration => 100, :title => "The thing") }


      context 'check without filter' do
        it 'check show film' do
          allow(netflix).to receive(:movies).and_return([movie])
          expect{netflix.show()}.to output("Now showing: The thing 13:00 - 14:40\n").to_stdout
        end

        it 'expect to withdraw payment for movie' do
          allow(netflix).to receive(:movies).and_return([movie])
          expect {netflix.show()} .to change(netflix, :wallet).from(5).to(3.5)
        end
      end

      context 'check with filter' do
        it 'return horror genre filter' do
          allow(netflix).to receive(:filter).and_return([movie])
          netflix.show(genre: 'Horror')
          expect(netflix).to have_received(:filter).with({:genre=>"Horror"})
        end

        it 'check show film' do
          allow(netflix).to receive(:filter).and_return([movie])
          expect{netflix.show(genre: 'Horror')}.to output("Now showing: The thing 13:00 - 14:40\n").to_stdout
        end

        it 'expect to withdraw payment for movie' do
          allow(netflix).to receive(:movies).and_return([movie])
          expect {netflix.show()} .to change(netflix, :wallet).from(5).to(3.5)
        end
      end

      it 'fails when movie with filter not found' do
        allow(netflix).to receive(:filter).and_return([])
        expect{netflix.show(genre: 'Comedy')}.to raise_error(MovieTheater::BaseTheater::MovieNotFound)
      end
    end

    context 'no money on wallet' do
      it 'get error' do
        expect{netflix.show()}.to raise_error(MovieTheater::Netflix::WithdrawError)
      end
    end
  end
end
