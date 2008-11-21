require 'test/unit'
require 'rubygems'
begin require 'redgreen' unless ENV['TM_FILENAME']; rescue LoadError; end

module TestDataHelper
  def test_input(input_string, *expected_outputs)
    test_data << { :input => input_string, :expected_output => expected_outputs }
  end

  def each_test_data
    test_data.each { |t| yield(t) }
  end

  def test_data
    @@test_data ||= []
  end
end

module Helpers
  def assert_equal_hashes(expected, hash)
    (expected.keys + hash.keys).uniq.each do |k|
      assert_equal expected[k], hash[k], "expected[#{k.inspect}] = #{expected[k].inspect} != hash[#{k.inspect}] = #{hash[k].inspect}"
    end
  end
end

class Test::Unit::TestCase
  include Helpers
end
