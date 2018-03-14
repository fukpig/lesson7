module MovieTheater
  module Cashbox
    class InvalidAmount < StandardError
      def initialize()
        super("Invalid amount, please enter valid amount")
      end
    end

    class InvalidTaker < StandardError
      def initialize()
        super("Police on way")
      end
    end

    #attr_accessor :cash

    def put_in_cash(amount)
      raise InvalidAmount if amount.cents <= 0
      self.add_to_cash(amount.cents)
    end

    def take(who)
      raise InvalidTaker unless who == "Bank"
      clean_cash
      puts "Encashment complete"
    end
  end
end
