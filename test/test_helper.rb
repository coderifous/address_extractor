module TestDataHelper

  TEST_DATA = []

  def test_input(input_string, *expected_outputs)
    test_data << { :input => input_string, :expected_output => expected_outputs }
  end

  def each_test_data
    test_data.each { |t| yield(t) }
  end
  
  def test_data
    TEST_DATA
  end
  
end

module Helpers

  def assert_equal_hashes(a,b)
    (a.keys + b.keys).uniq.each do |k|
      assert_equal a[k], b[k], "a[#{k.inspect}] = #{a[k].inspect} != b[#{k.inspect}] = #{b[k].inspect}"
    end
  end

  def assert_first_address_string(string)
    assert_match /^123 Foo St\., Someplace FL\s*$/, string
  end
  
end
