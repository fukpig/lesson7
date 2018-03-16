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

    @cash = Money.new(0, "USD")

    def put_in_cash(amount)
      raise InvalidAmount if amount.cents <= 0
      #if remove checking for nil => undefined method `+' for nil:NilClass or set @cash in netflix class
      @cash = Money.new(0, "USD") if @cash.nil?
      @cash += amount
    end

    def get_money_in_cashbox
      @cash.format
    end

    def take_money_from_cashbox(who)
      raise InvalidTaker unless who == "Bank"
      @cash = Money.new(0, "USD")
      puts "Encashment complete"
    end

  end
end
