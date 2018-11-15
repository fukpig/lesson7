# define usual theater with own cashbox
require 'csv'
require 'time'
require_relative 'base.rb'
require_relative '../cashbox.rb'

module MovieTheater
  module Theatres
    class Theater < Theatres::Base
      include Cashbox
      class InvalidTimePeriod < StandardError
        def initialize
          super('In that period we doesnt show movies, sorry')
        end
      end

      class ConclusionPeriods < StandardError
        def initialize
          super('Conclusion of periods')
        end
      end

      class InvalidTime < StandardError
        def initialize
          super('Invalid time, please enter valid time')
        end
      end

      class Hall
        attr_accessor :title, :color, :places

        def initialize(args)
          args.map { |k, v| instance_variable_set("@#{k}", v) unless v.nil? }
        end
=begin
        def method_missing(attribute_name, *value)
          if !value.empty?
            define_singleton_method("#{attribute_name}".to_sym) { value }
          end
        end
=end
      end

      class Period
        attr_accessor :time

        def initialize(time, &block)
          @time = time
          instance_eval &block
          convert_stringtime_to_time
        end

        def method_missing(attribute_name, *value)
          if !value.empty?
            define_singleton_method("#{attribute_name}".to_sym) { value.count == 1 && attribute_name != :hall ? value[0] : value }
          end
        end

        private

        def convert_stringtime_to_time
          time = @time.to_a
          @time = [Time.parse(time[0]),Time.parse(time[-1])]
        end

      end

      FILE_URL = "movies.txt"

      attr_accessor :halls

      def initialize(&block)
        super(FILE_URL)
        @halls = []
        @periods = []
        @schedule = {}
        #TheatreBuilder.new(self, &block) if block_given?
        instance_eval &block
        generate_schedule
      end

      def get_hall(color)
        @halls.each do |hall|
          if hall.color == color
            return hall
          end
        end
      end

      def generate_schedule
        @periods.each do |period|
          movie = get_movie(period)
          puts movie
          if !@schedule.key? movie.title
            @schedule[movie.title] = []
          end

#          puts period.hall
=begin
          @schedule[movie.title].push({
            :description => period.description,
            :time => period.time[0],
            :title => movie.title,
            :hall => get_hall(period.hall
            :places =>
          })
=end

        end
      end

      def show_schedule
        puts "Today in cinema:"
        @schedule.each do |key, movie|
          @schedule[key].each do |period|
            puts "Title:" + period[:title] + " Time:" + period[:time].to_s + " Price:" + period[:price] + " Places:" + period[:place]
          end
        end
      end

      def get_movie(period)
        filters = prepare_filters(period)
        return filter(filters).sample
      end

      def prepare_filters(period)
        filters = {}
        if period.filters.is_a?(Hash)
          filters = period.filters
        end

        title = period.title
        if !title.nil?
          filters[:title] = title
        end

        filters
      end

      def hall(color, options)
        hall = Hall.new({:color => color, :title => options[:title], :places => options[:places]})
        @halls.push(hall)
      end

      def period(time, &block)
        period = Period.new(time, &block)
        raise ConclusionPeriods if !is_period_valid?(@periods, period)
        @periods.push(period)
      end

      def is_period_valid?(periods, new_period)
        new_period_time = new_period.get_parsed_time
        new_period.hall.each do |new_hall|
          periods.each do |period|
              period.hall.each do |hall|
                if new_hall == hall && new_period.time[0] >= period.time[0] && new_period.time[1] <= period.time[1]
                  return false
                end
              end
          end
        end
        return true
      end

    end
  end
end
