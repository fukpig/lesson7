class Test
    @@test = 0
    @test = 1
    test1 = 2

    def show()
	     puts "test = " + test1.to_s
    end

    def self.show()
	     puts "test = " + @test.to_s
    end
end

test = Test.new
test.show()
Test.show()
