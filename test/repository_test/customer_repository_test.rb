require_relative '../test_helper'
require_relative '../../lib/customer_repository'

class CustomerRepositoryTest < Minitest::Test

  attr_reader :customer_repository

  def setup
    file = "./test/data_fixtures/customers_fixture.csv"
    @customer_repository = CustomerRepository.new(Minitest::Mock.new)
    @customer_repository.from_csv(file)
  end

  def test_customer_repo_exists
    assert customer_repository
  end

  def test_all_returns_an_array
    assert_kind_of Array, customer_repository.all
  end

  def test_all_returns_an_array_of_all_customer_objects
    customer_repository.all.all? {|customer| assert_kind_of Customer, customer}
  end

  def test_all_includes_all_customers
    assert_equal 35, customer_repository.all.length
  end

  def test_find_by_id_finds_customer_with_matching_id
    id = 1
    customer = customer_repository.find_by_id(id)
    assert_equal 1, customer.id
  end

  def test_find_all_by_first_name_returns_customer_with_matching_first_name
    first_name = 'Joey'
    customers = customer_repository.find_all_by_first_name(first_name)
    assert_equal 1, customers.length
    assert_equal first_name, customers.first.first_name
  end

  def test_find_all_by_first_name_returns_all_customers_with_fragment_in_name
    fragment = 'y'
    customers = customer_repository.find_all_by_first_name(fragment)
    assert_equal 7, customers.length
    customers.all? {|customer| customer.first_name.include?(fragment)}
  end

  def test_find_all_by_first_name_returns_empty_array_when_there_are_no_matches
    fragment = 'zzzzz'
    customers = customer_repository.find_all_by_first_name(fragment)
    assert_equal [], customers
  end

 def test_find_all_by_last_name_returns_customer_with_matching_last_name
    last_name = 'Ondricka'
    customers = customer_repository.find_all_by_last_name(last_name)
    assert_equal 1, customers.length
    assert_equal last_name, customers.first.last_name
  end

  def test_find_all_by_last_name_returns_all_customers_with_fragment_in_name
    fragment = 'y'
    customers = customer_repository.find_all_by_last_name(fragment)
    assert_equal 5, customers.length
    customers.all? {|customer| customer.last_name.include?(fragment)}
  end

  def test_find_all_by_last_name_returns_empty_array_when_there_are_no_matches
    fragment = 'zzzzz'
    customers = customer_repository.find_all_by_last_name(fragment)
    assert_equal [], customers
  end

  def test_customer_repo_knows_its_parent
    customer_repository.parent.expect(:find_merchants_by_customer_id, nil, [3333])
    customer_repository.find_merchants(3333)
    customer_repository.parent.verify
  end

  def test_inspect_returns_class_and_size
    inspection = "#<CustomerRepository 35 rows>"
    assert_equal inspection, customer_repository.inspect
  end

end