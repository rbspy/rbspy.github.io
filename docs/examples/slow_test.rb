require "test/unit"

class TestSimpleNumber < Test::Unit::TestCase
    def test_simple
        assert_equal(4, slow_function)
    end
end

def slow_function
    sleep(4)
    return 4
end
