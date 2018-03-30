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

      # filtered_movies = filter(filters.fetch(:built_in)).select{|m| apply_custom_filters(m, filters.fetch(:custom)) }
      def show(filter_hash = nil)
        filters = devide_filters(filter_hash)
        filtered_movies = movies
        filtered_movies = filter_built_in(filtered_movies, filters.fetch(:built_in)) unless filters.fetch(:built_in).empty?
        filtered_movies = filtered_movies.select { |m| apply_custom_filters(m, filters.fetch(:custom)) } unless filters.fetch(:custom).empty?
        filtered_movies = filtered_movies.select { |m| yield(m) } if block_given?
        movie = filtered_movies.sample
        raise MovieNotFound, filter_hash if movie.nil?
        withdraw(movie.cost)
        super(movie)
      end

      private

      def filter_built_in(movies, filters)
        filters.reduce(movies) { |filtered, (key, value)| filtered.select { |m| m.matches?(key, value) } }
      end

      def built_in_filter?(parameter_name)
        MOVIE_HASH_KEYS.include? parameter_name
      end

      def apply_custom_filters(movie, filters)
        result = false
        filters.each do |f|
          filter_name = f.keys[0]
          filter_value = f.values[0]

          filter = @client_filters[filter_name]
          raise FilterNotFound, filter_name if filter.nil?

          result = filter.call(movie, filter_value)
        end
        result
      end

      def devide_filters(filter_hash)
        filters = { built_in: {}, custom: [] }
        filter_hash.map { |k, v| built_in_filter?(k) ? filters[:built_in][k] = v : filters[:custom].push(k => v) } unless filter_hash.nil?
        filters
      end

      def get_filtered_film(filter_hash)
        filtered_movies = filter(filter_hash)
        movie = filtered_movies.sample
        raise MovieNotFound, filter_hash if movie.nil?
        movie
      end
    end
  end
end
