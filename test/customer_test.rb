require_relative 'test_helper'
require_relative '../lib/customer'

class CustomerTest < Minitest::Test

  attr_reader :customer
  
  def setup
    @customer = Customer.new({
      :id          => "6",
      :first_name  => "Joan",
      :last_name   => "Clarke",
      :created_at  => Time.now.to_s,
      :updated_at  => Time.now.to_s},
      Minitest::Mock.new)
  end

  def test_customer_exists
    assert customer
  end

  def test_customer_knows_its_id
    assert_equal 6, customer.id
  end

  def test_customer_knows_its_first_name
    assert_equal "Joan", customer.first_name
  end

  def test_customer_knows_its_last_name
    assert_equal "Clarke", customer.last_name
  end

  def test_customer_knows_when_it_was_created
    assert_equal Time.now.to_s, customer.created_at.to_s
  end

  def test_customer_knows_when_it_was_updated
    assert_equal Time.now.to_s, customer.updated_at.to_s
  end

  def test_customer_knows_its_parent
    customer.parent.expect(:find_merchants, nil, [3333])
    customer.merchants(3333)
    customer.parent.verify
  end

end