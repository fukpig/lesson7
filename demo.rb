require './lib/movie_theater.rb'

I18n.config.available_locales = :en

netflix = MovieTheater::Theatres::Netflix.new("movies.txt")
netflix.pay(25)



netflix.define_filter(:terminators) {  |movie| movie.title.include?('Terminator') }
netflix.define_filter(:terminator2) {  |movie, year| movie.title.include?('Terminator') && movie.release_year == year }
netflix.define_filter(:terminator2_by_year, from: :terminator2, arg: 1991)

puts netflix.show(genre: 'Drama', release_year: 2001..2005)
puts netflix.show(terminators: true)
puts netflix.show(terminator2: 1991)
puts netflix.show{ |movie| !movie.title.include?('Terminator') && movie.genre.include?('Action') && movie.release_year > 2003}
puts netflix.show(genre: 'Action', terminator2: 1991) { |movie| !movie.title.include?('Batman') }
