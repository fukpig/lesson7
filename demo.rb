require './movie_theater/module.rb'

I18n.config.available_locales = :en

netflix = MovieTheater::Netflix.new("movies.txt")
netflix2 = MovieTheater::Netflix.new("movies.txt")
puts netflix.pay(20)
puts netflix2.pay(30)

#netflix.take('Bank')
puts netflix.cash
puts netflix2.cash


theater = MovieTheater::Theater.new("movies.txt")
theater2 = MovieTheater::Theater.new("movies.txt")


theater.buy_ticket('Psycho')
theater2.buy_ticket('City Lights')

#theater.take('Bank')
puts theater.cash
puts theater2.cash

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
