module MovieTheater
  module Theatres
    module Finders
      class CountryFinder

        def initialize(theater)
          @theater = theater
        end

        def method_missing(country)
          @theater.filter({:country => country.to_s})
        end

      end
    end
  end
end
