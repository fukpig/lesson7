module MovieTheater
  module Cashbox
    class InvalidAmount < StandardError
      def initialize
        super('Invalid amount, please enter valid amount')
      end
    end

    class InvalidTaker < StandardError
      def initialize
        super('Police on way')
      end
    end

    def pay(amount)
      raise InvalidAmount if amount.cents <= 0
      @cash = cash + amount
    end

    def cash
      @cash ||= Money.new(0, 'USD')
    end

    def clean
      @cash = Money.new(0, 'USD')
    end

    def take(who)
      raise InvalidTaker unless who == 'Bank'
      @cash = Money.new(0, 'USD')
      puts 'Encashment complete'
    end
  end
end
