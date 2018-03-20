module MovieTheater
  module Theatres
    # define class  Therater
    require 'csv'
    require_relative 'base.rb'
    require_relative '../cashbox.rb'

    class Theater < Theatres::Base
      include Cashbox

      class InvalidTimePeriod < StandardError
        def initialize()
          super("In that period we doesnt show movies, sorry")
        end
      end

      class InvalidTime < StandardError
        def initialize()
          super("Invalid time, please enter valid time")
        end
      end


      TIME_PERIODS = { 9..11 => :morning, 12..18 => :day, 19..23 => :evening }
      COST_PERIODS = { :morning => 3, :day => 5, :evening => 10 }
      DAY_GENRES = ["Comedy", "Adventure"]
      EVENING_GENRES = ["Horror", "Drama"]
      SCHEDULE = {:morning => {:period => :ancient}, :day => {:genre => Regexp.union(DAY_GENRES)}, :evening => {:genre => Regexp.union(EVENING_GENRES)}}
      def when?(title)
        movie = filter(title: title).first
        raise MovieNotFound.new(title: title) if movie.nil?
        find_time_by_movie(movie) or raise MovieNotFound.new(title: title)
      end

      def show(time = Time.now.hour)
        hour = time.is_a?(Integer) ? time : guess_hour(time)
        time_period = get_time_period(hour)
        raise InvalidTimePeriod if time_period.nil?
        movie = find_movie_by_time(time_period)
        raise MovieNotFound.new(time: time) if movie.nil?
        amount = Money.new(COST_PERIODS[time_period]*100, "USD")
        pay(amount)
        super(movie)
      end

      private

      def guess_hour(time)
        m = time.match(/^([01]?\d):([0-5]\d)$/) or fail "Wrong time format"
        m[1].to_i
      end

      def get_time_period(hour)
        period = TIME_PERIODS.detect { |period, _| period.cover?(hour) }
        raise InvalidTimePeriod if period.nil?
        period.last
      end

      def find_time_by_movie(movie)
        SCHEDULE.detect { |_, filters| movie.matches_all?(filters) }.first
      end

      def find_movie_by_time(time)
        filter(SCHEDULE[time]).sample
      end
    end
  end
end
