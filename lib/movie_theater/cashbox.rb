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

    def pay(amount)
      raise InvalidAmount if amount.cents <= 0
      #if remove checking for nil => undefined method `+' for nil:NilClass or set @cash in netflix class
      @cash = Money.new(0, "USD") if @cash.nil?
      @cash += amount
    end

    def cash
      @cash = Money.new(0, "USD") if @cash.nil?
      @cash
    end

    def take(who)
      raise InvalidTaker unless who == "Bank"
      @cash = Money.new(0, "USD")
      puts "Encashment complete"
    end

  end
end
