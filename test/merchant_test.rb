require_relative 'test_helper'
require_relative '../lib/merchant'

class MerchantTest < Minitest::Test

  attr_reader :merchant

  def setup
    @merchant = Merchant.new({:id         => '5', 
                              :name       => "Turing School",
                              :created_at => Time.now.to_s},
                              Minitest::Mock.new)
  end

  def test_merchant_exists
    assert merchant
  end

  def test_merchant_knows_id
    assert_equal 5, merchant.id
  end

  def test_merchant_knows_name
    assert_equal "Turing School", merchant.name
  end

  def test_merchant_knows_when_it_was_created
    time = Time.now
    assert_equal time.to_s, merchant.created_at.to_s
  end

  def test_merchant_knows_its_parent
    merchant.parent.expect(:find_invoices, nil, [5])
    merchant.invoices
    merchant.parent.verify
  end

  def test_merchant_knows_its_customer
    merchant.parent.expect(:find_customers, nil, [5])
    merchant.customers
    merchant.parent.verify
  end
  
end