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
  def assert_equal_hashes(a,b)
    (a.keys + b.keys).uniq.each do |k|
      assert_equal a[k], b[k], "a[#{k.inspect}] = #{a[k].inspect} != b[#{k.inspect}] = #{b[k].inspect}"
    end
  end
end

class Test::Unit::TestCase
  include Helpers
end
