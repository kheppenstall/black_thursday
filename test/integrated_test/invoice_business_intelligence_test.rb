require_relative '../test_helper'
require_relative '../../lib/sales_engine'

class InvoiceBusinessIntelligenceTest < Minitest::Test

  attr_reader :sales_engine

  def setup
    @sales_engine = SalesEngine.from_csv({
      :invoices => "./test/data_fixtures/invoices_fixture.csv",
      :transactions => "./test/data_fixtures/transactions_fixture.csv",
      :invoice_items => "./test/data_fixtures/invoice_items_fixture.csv"
    })
  end

  def test_if_paid_invoice_is_paid_in_full
    invoice = sales_engine.invoices.find_by_id(26)
    assert invoice.is_paid_in_full?
  end

  def test_if_unpaid_invoice_is_paid_in_full
    invoice = sales_engine.invoices.find_by_id(2)
    refute invoice.is_paid_in_full?
  end

  def test_total_returns_zero_when_invoice_has_no_items
    invoice = sales_engine.invoices.find_by_id(4966)
    assert_equal 0, invoice.total
  end

  def test_total_returns_total_when_invoice_has_items
    invoice = sales_engine.invoices.find_by_id(26)
    assert_equal 15956.23, invoice.total
  end

end
