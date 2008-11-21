require 'address_extractor'
require 'test_helper'
include TestDataHelper

class AddressExtractorTest < Test::Unit::TestCase
  def test_first_address_extraction
    each_test_data do |test_data|
      address = AddressExtractor.first_address(test_data[:input])
      flunk "No address found in:\n#{test_data[:input]}" if address.nil?
      assert_equal_hashes address, test_data[:expected_output].first
    end
  end

  def test_find_addresses
    each_test_data do |test_data|
      addresses = AddressExtractor.find_addresses(test_data[:input])
      assert_equal addresses.size, test_data[:expected_output].size
      test_data[:expected_output].each do |expected_output|
        assert_equal_hashes addresses.shift, expected_output
      end
    end
  end

  def test_replace_first_address
    string = AddressExtractor.replace_first_address(test_data.first[:input]) do |address_hash, address|
      assert_equal_hashes address_hash, test_data.first[:expected_output].first
      assert_match /^\s*123 Foo St., Someplace FL\s*/, address
      "skidoosh"
    end
    assert_match /Please send the package to skidoosh/, string
  end

  def test_replace_addresses
    string = AddressExtractor.replace_addresses(test_data.first[:input]) do |address_hash, address|
      "skidoosh"
    end
    assert_match /Please send the package to skidoosh/, string
    assert_match /via mail at:\s+skidoosh/, string
  end

  def test_no_addresses_found
    assert_nil AddressExtractor.first_address("foo")
    assert_equal [], AddressExtractor.find_addresses("foo")
    assert_equal "foo", AddressExtractor.replace_first_address("foo")
    assert_equal "foo", AddressExtractor.replace_addresses("foo")
  end
end

# Test Input/Expected outputs defined below using test_input helper
# Expanding the tests will probably start with adding new test input

test_input "
    Please send the package to 123 Foo St., Someplace FL

    My phone number is 123-1234 and St. Marc of Israel can be reached
    via mail at:
      123 Goob Avenue
      Apt 123
      Nice Town CA 12345",
  { :street1 => "123 Foo St.", :street2 => nil, :city => "Someplace", :state => "FL", :zip => nil },
  { :street1 => "123 Goob Avenue", :street2 => "Apt 123", :city => "Nice Town", :state => "CA", :zip => "12345" }

test_input "Let's meet tomorrow at noon at 123 Foo Bar Street, Scooby NY 12345",
  { :street1 => "123 Foo Bar Street", :street2 => nil, :city => "Scooby", :state => "NY", :zip => "12345" }

test_input "Let's meet tomorrow at noon at 123 Foo Bar Street, Scooby, NY 12345",
  { :street1 => "123 Foo Bar Street", :street2 => nil, :city => "Scooby", :state => "NY", :zip => "12345" }

test_input "Let's meet tomorrow at noon at 123 Foo Bar Street, Scooby, NY, 12345",
  { :street1 => "123 Foo Bar Street", :street2 => nil, :city => "Scooby", :state => "NY", :zip => "12345" }

test_input "Let's meet tomorrow at noon at 123 Foo Bar Street, 12345",
  { :street1 => "123 Foo Bar Street", :street2 => nil, :city => nil, :state => nil, :zip => "12345" }

test_input "
  Apple Computer, Inc.
  1 Infinite Loop
  Cupertino, CA 95014",
  { :street1 => "1 Infinite Loop", :street2 => nil, :city => "Cupertino", :state => "CA", :zip => "95014" }

test_input "Apple Computer, Inc. 1 Infinite Loop, Cupertino, CA 95014",
  { :street1 => "1 Infinite Loop", :street2 => nil, :city => "Cupertino", :state => "CA", :zip => "95014" }

