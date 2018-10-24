# define base movie
require 'virtus'
require_relative '../theatres/base.rb'

module MovieTheater
  module Movies
    class Base

      class ConstantError < StandardError
        attr_reader :constant_name

        def initialize(constant_name)
          @constant_name = constant_name
          super("CONSTANT #{constant_name} not set")
        end
      end

      include Virtus.model

      attribute :href, String
      attribute :genre, Array[String]
      attribute :title, String
      attribute :release_year, Integer
      attribute :country, String
      attribute :release_date, Integer
      attribute :full_duration_definition, String
      attribute :duration, Integer, :default => lambda { |movie, _| movie.full_duration_definition.split(' ')[0] }
      attribute :duration_definition, String, :default => lambda { |movie, _| movie.full_duration_definition.split(' ')[1] }
      attribute :rating, Float
      attribute :director, String
      attribute :actors, Array[String]

      def genre=(value)
        genres = value.split(',')
        genres.map! { |g| g = g.downcase}
        super genres
      end

      def country=(value)
        super value.downcase
      end

      def actors=(value)
        super value.split(',')
      end

      def cost
        raise ConstantError, 'cost' unless defined? self.class::COST
        self.class::COST
      end

      def period
        raise ConstantError, 'period' unless defined? self.class::PERIOD
        self.class::PERIOD
      end

      def to_s
        "#{@title} (#{@release_date}; #{@genre.join(',')}) - #{@duration} #{@duration_definition}  #{@country}"
      end

      def inspect
        "#<Movie \"#{@title}\" (#{@release_year})>"
      end

      # rubocop:disable CaseEquality
      def matches?(key, value)
        if key.to_s.include? "exclude"
          key = key.to_s.split("_")[1]
          return Array(send(key)).any? { |v| value != v }
        end

        if value.kind_of?(Array)
          return value.all? { |e|   send(key).include?(e) }
        end

        return Array(send(key)).any? { |v| value === v }
      end
      # rubocop:enable CaseEquality

      def matches_all?(filter)
        filter.any? { |k, v| matches?(k, v) }
      end

      def method_missing(attribute_name)

      end

    end
  end
end
