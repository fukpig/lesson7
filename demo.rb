require './lib/movie_theater.rb'

I18n.config.available_locales = :en

theater = MovieTheater::Theatres::Theater.new("movies.txt")
theater2 = MovieTheater::Theatres::Theater.new("movies.txt")

theater.show('10:00')
theater2.show('16:00')

theater.take('Bank')
puts theater.cash
puts theater2.cash

netflix = MovieTheater::Theatres::Netflix.new("movies.txt")
netflix2 = MovieTheater::Theatres::Netflix.new("movies.txt")
netflix3 = MovieTheater::Theatres::Netflix.new("movies.txt")

puts netflix.pay(20)
puts netflix2.pay(30)

puts MovieTheater::Theatres::Netflix.cash

netflix.take('Bank')
puts MovieTheater::Theatres::Netflix.cash

#puts MovieTheater::Netflix.cash
#puts MovieTheater::Netflix.cash

=begin
puts netflix.how_much?('The Terminator')

puts netflix.show(genre: 'Horror', period: :modern)
puts netflix.show()
puts netflix.wallet

puts "========"
theater = Theater.new("movies.txt")

puts theater.when?('City Lights')
puts theater.when?('Psycho')
puts theater.when?('Back to the Future')


puts theater.show("10:30")
puts theater.show("13:00")
=end
