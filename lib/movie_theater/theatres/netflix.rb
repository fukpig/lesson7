# define online theater with general cashbox
module MovieTheater
  module Theatres
    require 'csv'
    require_relative 'base.rb'
    require_relative '../cashbox.rb'

    class Netflix < Theatres::Base
      extend Cashbox

      class PaymentError < StandardError
        def initialize
          super('Payment Error')
        end
      end

      class WithdrawError < StandardError
        def initialize
          super('Withdraw Error')
        end
      end

      class FilterNotFound < ArgumentError
        attr_reader :filename
        def initialize(filter_name)
          @filter_name = filter_name
          super("Filter #{filter_name} not found")
        end
      end

      attr_reader :wallet, :client_filters
      def initialize(filename)
        super(filename)
        @wallet = Money.new(0, 'USD')
        @client_filters = {}
      end

      def check_money(amount)
        raise WithdrawError if (@wallet.cents - amount.cents) < 0
      end

      def withdraw(amount)
        amount = Money.new(amount * 100, 'USD')
        check_money(amount)
        @wallet -= amount
      end

      def pay(amount)
        raise PaymentError unless amount > 0
        amount = Money.new(amount * 100, 'USD')
        @wallet += amount
        self.class.pay(amount)
      end

      def how_much?(title)
        movie = filter(title: title).first
        raise MovieNotFound.new(title: title) if movie.nil?
        movie.cost
      end

      def define_filter(filter_name, from: nil, arg: nil, &block)
        unless from.nil?
          filter = @client_filters[from]
          raise FilterNotFound, from if filter.nil?
        end
        filter = { from: from, arg: arg, filter_proc: block }
        @client_filters[filter_name] = filter
      end

      def show(filter = nil)
        if !filter.nil? && !block_given?
          filter_name = filter.keys[0]
          filter_value = filter.values[0]

          filter = @client_filters[filter_name]
          raise FilterNotFound, filter_name if filter.nil?

          filter_proc = filter[:from].nil? ? filter[:filter_proc] : @client_filters[filter[:from]][:filter_proc]
          filter_proc_value = filter[:arg].nil? ? filter_value : filter[:arg]

          movie = movies.select { |m| filter_proc.call(m, filter_proc_value) }.sample
        end

        movie = movies.select { |m| yield(m) }.sample if filter.nil? && block_given?

        raise MovieNotFound, filter if movie.nil?
        withdraw(movie.cost)
        super(movie)
      end

      private

      def get_filtered_film(filter_hash)
        filtered_movies = filter(filter_hash)
        movie = filtered_movies.sample
        raise MovieNotFound, filter_hash if movie.nil?
        movie
      end
    end
  end
end
