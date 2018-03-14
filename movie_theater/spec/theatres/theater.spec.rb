require_relative '../spec_helper'
require 'rspec/its'
require 'timecop'

require_relative '../../theatres/theater.rb'
I18n.config.available_locales = :en


describe MovieTheater::Theater do
  let(:file) { File.join(File.dirname(__FILE__), "../spec_movies.txt") }
  let(:theater) { MovieTheater::Theater.new(file) }


  describe '#add_to_cash' do
    it 'get 5 dollars in cashbox' do
      theater.add_to_cash(5)
      expect(theater.cash).to eq "$5.00"
    end
  end

  describe '#buy_ticket' do
    it 'find horror movie and buy ticket' do
      theater.buy_ticket("The Shining")
      expect(theater.cash).to eq "$10.00"
    end
    it 'find classic movie' do
      theater.buy_ticket("Casablanca")
      expect(theater.cash).to eq "$3.00"
    end
    it 'find adventure movie' do
      theater.buy_ticket("North by Northwest")
      expect(theater.cash).to eq "$5.00"
    end
    it 'get error when movie cant be find in text file' do
      expect{theater.buy_ticket("La la land")}.to raise_error(MovieTheater::BaseTheater::MovieNotFound)
    end
    it 'get error when movie not in schedule' do
      expect{theater.buy_ticket("Scream")}.to raise_error(MovieTheater::BaseTheater::MovieNotFound)
    end
  end

  describe '#when?' do
    it 'find movie' do
      expect(theater.when?("The Shining")).to eq :evening
    end
    it 'get error when movie cant be find in text file' do
      expect{theater.when?("La la land")}.to raise_error(MovieTheater::BaseTheater::MovieNotFound)
    end
    it 'get error when movie not in schedule' do
      expect{theater.when?("Scream")}.to raise_error(MovieTheater::BaseTheater::MovieNotFound)
    end
  end

  describe '#show' do
    before { Timecop.freeze(Time.local(2018, 3, 12, 13, 0, 0)) }

    context "check filter works properly" do
      let (:movie) { double("ClassicMovie", :duration => 100, :title => "The thing") }
        it 'return period ancient filter' do
          allow(theater).to receive(:filter).and_return([movie])
          theater.show(10)
          expect(theater).to have_received(:filter).with({:period=>:ancient})
        end
    end

    context "check morning classic movie" do
      let (:movie) { double("ClassicMovie", :duration => 100, :title => "The thing") }
      it "show film from morning period" do
        allow(theater).to receive(:filter).and_return([movie])
        expect{theater.show(10)}.to output("Now showing: The thing 13:00 - 14:40\n").to_stdout
      end
    end

    context "check day adventure or comedy movie" do
      context "check filter works properly" do
        let (:movie) { double("ModernMovie", :duration => 110, :title => "Indiana Jones", :genre => ["Adventure"]) }
          it 'return adventure or comedy regexp' do
            allow(theater).to receive(:filter).and_return([movie])
            theater.show(13)
            expect(theater).to have_received(:filter).with({:genre=>/Comedy|Adventure/})
          end
      end

      context "adventure movie" do
        let (:movie) { double("ModernMovie", :duration => 110, :title => "Indiana Jones", :genre => ["Adventure"]) }
          it 'when adventure film' do
            allow(theater).to receive(:filter).and_return([movie])
            expect{theater.show(13)}.to output("Now showing: Indiana Jones 13:00 - 14:50\n").to_stdout
          end
      end

      context "comedy movie" do
        let (:movie) { double("ModernMovie", :duration => 110, :title => "Dumb and dumber", :genre => ["Comedy"]) }
          it 'when adventure film' do
            allow(theater).to receive(:filter).and_return([movie])
            expect{theater.show(13)}.to output("Now showing: Dumb and dumber 13:00 - 14:50\n").to_stdout
          end
      end
    end


    context "check evening horror or drama movie" do
      context "check filter works properly" do
        let (:movie) { double("ModernMovie", :duration => 110, :title => "Alien", :genre => ["Horror"]) }
          it 'return horror or drama regexp' do
            allow(theater).to receive(:filter).and_return([movie])
            theater.show(21)
            expect(theater).to have_received(:filter).with({:genre=>/Horror|Drama/})
          end
      end


      context "adventure movie" do
        let (:movie) { double("ModernMovie", :duration => 110, :title => "Alien", :genre => ["Horror"]) }
          it 'when horror film' do
            allow(theater).to receive(:filter).and_return([movie])
            expect{theater.show(21)}.to output("Now showing: Alien 13:00 - 14:50\n").to_stdout
          end
      end

      context "drama movie" do
        let (:movie) { double("ModernMovie", :duration => 110, :title => "Bridgit jones", :genre => ["Drama"]) }
          it 'when drama film' do
            allow(theater).to receive(:filter).and_return([movie])
            expect{theater.show(21)}.to output("Now showing: Bridgit jones 13:00 - 14:50\n").to_stdout
          end
      end
    end

    context "get error with invalid time" do
      it "return invalid time period" do
        expect{theater.show("07:00")}.to raise_error(MovieTheater::Theater::InvalidTimePeriod)
      end
    end
  end
end
