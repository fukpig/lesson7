module MovieTheater
  module Theatres
    # define class  Netflix
    require 'csv'
    require_relative 'base.rb'
    require_relative '../cashbox.rb'

    class Netflix < Theatres::Base
      extend Cashbox

      class PaymentError < StandardError
        def initialize()
          super("Payment Error")
        end
      end

      class WithdrawError < StandardError
        def initialize()
          super("Withdraw Error")
        end
      end

      attr_reader :wallet
      def initialize(filename)
        super(filename)
        @wallet = Money.new(0, "USD")
      end

      def check_money(amount)
        raise WithdrawError if (@wallet.cents - amount.cents) < 0
      end

      def withdraw(amount)
        amount = Money.new(amount*100, "USD")
        check_money(amount)
        @wallet -= amount
      end

      def pay(amount)
        raise PaymentError unless amount > 0
        amount = Money.new(amount*100, "USD")
        @wallet += amount
        self.class.put_in_cash(amount)
      end

      def how_much?(title)
        movie = filter({:title => title}).first
        raise MovieNotFound.new(title: title) if movie.nil?
        movie.cost
      end

      def show(filter_hash = nil)
        movie = filter_hash.nil? ? movies.sample : get_filtered_film(filter_hash)
        withdraw(movie.cost)
        super(movie)
      end

      def self.cash()
        Theatres::Netflix.get_money_in_cashbox
      end

      def take(who)
        Theatres::Netflix.take_money_from_cashbox(who)
      end

      private

      def get_filtered_film(filter_hash)
        filtered_movies = filter(filter_hash)
        movie = filtered_movies.sample
        raise MovieNotFound.new(filter_hash) if movie.nil?
        movie
      end
    end
  end
end
