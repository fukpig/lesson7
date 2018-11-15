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

      class StringArray < Virtus::Attribute
        def coerce(value)
          value.split(',')
        end
      end

      include Virtus.model

      attribute :href, String
      attribute :genre, StringArray
      attribute :title, String
      attribute :release_year, Integer
      attribute :country, String
      attribute :release_date, Integer
      attribute :duration, String
      attribute :rating, Float
      attribute :director, String
      attribute :actors, StringArray

      def cost
        raise ConstantError, 'cost' unless defined? self.class::COST
        self.class::COST
      end

      def period
        raise ConstantError, 'period' unless defined? self.class::PERIOD
        self.class::PERIOD
      end

      def to_s
        "#{@title} (#{@release_year}; #{@genre.join(',')}) - #{@duration}  #{@country}"
      end

      def inspect
        "#<Movie \"#{@title}\" (#{@release_year})>"
      end

      # rubocop:disable CaseEquality
      def matches?(key, value)
        if key.to_s.include? "exclude"
          key = key.to_s.split("_")[1]
          return Array(send(key)).any? { |v| value.downcase != v.downcase }
        end

        if value.kind_of?(Array)
          return value.all? { |e| send(key).map(&:downcase).include?(e) }
        end

        if value.kind_of?(String)
          return Array(send(key)).any? { |v| value.downcase === v.downcase }
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
