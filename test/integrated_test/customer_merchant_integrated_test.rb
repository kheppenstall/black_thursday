require_relative '../test_helper'
require_relative '../../lib/sales_engine'

class CustomerMerchantIntegratedTest < Minitest::Test

  attr_reader :sales_engine

  def setup
    @sales_engine = SalesEngine.from_csv({
      :customers => "./test/data_fixtures/customers_fixture.csv",
      :merchants => "./test/data_fixtures/merchants_fixture.csv",
      :invoices => "./test/data_fixtures/invoices_fixture.csv",
    })
  end

  def test_merchant_knows_its_customers
    merchant = sales_engine.merchants.find_by_id(12334195)
    customers = merchant.customers
    assert_equal 13, customers.length
    assert customers.any? {|customer| customer.id == 200}
  end

  def test_merchant_with_no_customers_returns_empty_array
    merchant = sales_engine.merchants.find_by_id(12334105)
    customers = merchant.customers
    assert_equal [], customers
  end

  def test_customer_knows_its_merchants
    customer = sales_engine.customers.find_by_id(200)
    merchants = customer.merchants
    assert_equal 1, merchants.length
    assert merchants.any? {|merchant| merchant.id == 12334195}
  end

  def test_customer_with_no_merchant_returns_nil_as_merchant_for_each_invoice
    customer = sales_engine.customers.find_by_id(2)
    merchants = customer.merchants
    assert merchants.all? {|merchant| merchant == nil}
  end
    
end