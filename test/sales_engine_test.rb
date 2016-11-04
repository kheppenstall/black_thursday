require_relative 'test_helper'
require_relative '../lib/sales_engine'

class SalesEngineTest < Minitest::Test

  attr_reader :sales_engine

  def setup
    @sales_engine = SalesEngine.from_csv({
      :items => "./test/data_fixtures/items_fixture.csv",
      :merchants => "./test/data_fixtures/merchants_fixture.csv",
      :invoices => "./test/data_fixtures/invoices_fixture.csv",
      :invoice_items => "./test/data_fixtures/invoice_items_fixture.csv",
      :customers => "./test/data_fixtures/customers_fixture.csv",
      :transactions => "./test/data_fixtures/transactions_fixture.csv"
    })
  end
  
  def test_sales_engine_exists
    assert sales_engine
  end

  def test_merchant_returns_a_merchant_repository_object
    assert_kind_of MerchantRepository, sales_engine.merchants
  end

  def test_item_returns_an_item_repository_object
    assert_kind_of ItemRepository, sales_engine.items
  end

  def test_invoices_returns_an_invoice_repository_object
    assert_kind_of InvoiceRepository, sales_engine.invoices
  end

  def test_invoice_items_returns_an_invoice_item_repository_object
    assert_kind_of InvoiceItemRepository, sales_engine.invoice_items
  end

  def test_customers_returns_a_customer_repository_object
    assert_kind_of CustomerRepository, sales_engine.customers
  end

  def test_customers_returns_a_customer_repository_object
    assert_kind_of TransactionRepository, sales_engine.transactions
  end

end