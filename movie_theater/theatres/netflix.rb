module MovieTheater
  # define class  Netflix
  require 'csv'
  require_relative 'base_theatre.rb'
  require_relative '../lib/cashbox/cashbox.rb'

  class Netflix < BaseTheater
    include Cashbox

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

    @@cash = Money.new(0, "USD")
    attr_reader :wallet
    def initialize(filename)
      super(filename)
      @wallet = 0
    end

    def cash()
      @@cash.format
    end

    def add_to_cash(amount)
      @@cash += Money.new(amount*100, "USD")
    end

    def check_money(amount)
      raise WithdrawError if (@wallet - amount) < 0
    end

    def withdraw(amount)
      check_money(amount)
      @wallet -= amount
    end

    def pay(amount)
      raise PaymentError unless amount > 0
      @wallet += amount
      put_in_cash(Money.new(amount, "USD"))
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

    private

    def get_filtered_film(filter_hash)
      filtered_movies = filter(filter_hash)
      movie = filtered_movies.sample
      raise MovieNotFound.new(filter_hash) if movie.nil?
      movie
    end

    def clean_cash
      @@cash = Money.new(0, "USD")
    end
  end
end
