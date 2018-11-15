require './lib/movie_theater.rb'

I18n.config.available_locales = :en

#netflix = MovieTheater::Theatres::Netflix.new("movies.txt")
#netflix.pay(25)

#puts netflix.by_genre.comedy
#puts netflix.by_country.usa

theater =
  MovieTheater::Theatres::Theater.new do
    hall :red, title: 'Красный зал', places: 100
    hall :blue, title: 'Синий зал', places: 50
    hall :green, title: 'Зелёный зал (deluxe)', places: 12

    period '09:00'..'11:00' do
      description 'Утренний сеанс'
      filters genre: 'comedy', release_year: 1900..1980
      price 10
      hall :red, :blue
    end


    period '11:00'..'16:00' do
      description 'Спецпоказ'
      title 'The Terminator'
      price 50
      hall :green
    end

    period '16:00'..'20:00' do
      description 'Вечерний сеанс'
      filters genre: ['action', 'drama'], release_year: 2007..Time.now.year
      price 20
      hall :red, :blue
    end

    period '19:00'..'22:00' do
      description 'Вечерний сеанс для киноманов'
      filters release_year: 1900..1945, exclude_country: 'usa'
      price 30
      hall :green
    end

  end

  theater.show_schedule

  #theater.buy('Film name', '16:30')
