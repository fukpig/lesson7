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
          filter_parent = @client_filters.fetch(from) { |key| raise FilterNotFound, key }
          block = proc { |m| filter_parent.call(m, arg) }
        end
        @client_filters[filter_name] = block
      end

      def show(**filters, &block)
        movie = prepare_movies(filters, block).sample
        raise MovieNotFound, filters if movie.nil?
        withdraw(movie.cost)
        super(movie)
      end

      private

      def prepare_movies(filters, block)
        builtin_filters, custom_filters = filters.partition { |key, _| MovieTheater::Movies::Base.instance_methods.include?(key) }.map(&:to_h)
        filter(builtin_filters)
          .yield_self { |res| filter_custom(res, custom_filters) }
          .yield_self { |res| block ? res.select(&block) : res }
      end

      def filter_custom(result, filters)
        filters.reduce(result) { |filtered, (filter_name, filter_value)| filtered.select { |m| client_filters.fetch(filter_name).call(m, filter_value) } }
      end
    end
  end
end
