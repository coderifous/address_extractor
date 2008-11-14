$: << File.dirname(__FILE__)+"/../lib"

require 'test/unit'
require 'address_extractor.rb'

class AddressExtractorTest < Test::Unit::TestCase

  def test_first_address_extraction
    address = AddressExtractor.first_address(DATA1)
    assert_first_address(address)
  end
  
  def test_find_addresses
    addresses = AddressExtractor.find_addresses(DATA1)
    assert_first_address  addresses[0]
    assert_second_address addresses[1]
  end
  
  def test_replace_first_address
    string = AddressExtractor.replace_first_address(DATA1) do |address_hash, address|
      assert_first_address address_hash
      assert_first_address_string address
      "skidoosh"
    end
    assert string =~ /Please send the package to skidoosh/
  end
  
  def test_replace_addresses
    string = AddressExtractor.replace_addresses(DATA1) do |address_hash, address|
      "skidoosh"
    end
    assert string =~ /Please send the package to skidoosh/
    assert string =~ /via mail at:\n  skidoosh/
  end
  
  module Helpers
    def assert_first_address(a)
      assert_not_nil a
      assert_equal "123 Foo St.", a[:street1]
      assert_equal nil,           a[:street2]
      assert_equal "Someplace",   a[:city]
      assert_equal "FL",          a[:state]
      assert_equal nil,           a[:zip]
    end
  
    def assert_first_address_string(string)
      assert_match /^123 Foo St\., Someplace FL\s*$/, string
    end
  
  
    def assert_second_address(a)
      assert_not_nil a
      assert_equal "123 Goob Avenue", a[:street1]
      assert_equal "Apt 123",         a[:street2]
      assert_equal "Nice Town",       a[:city]
      assert_equal "CA",              a[:state]
      assert_equal "123456",          a[:zip]
    end
  end
  include Helpers
end

DATA1 = <<EOF
Please send the package to 123 Foo St., Someplace FL

My phone number is 123-1234 and St. Marc of Israel can be reached
via mail at:
  123 Goob Avenue
  Apt 123
  Nice Town CA 123456
EOF
