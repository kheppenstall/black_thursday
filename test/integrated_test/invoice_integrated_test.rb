require_relative '../test_helper'
require_relative '../../lib/sales_engine'

class InvoiceIntegratedTest < Minitest::Test

  attr_reader :sales_engine

  def setup
    @sales_engine = SalesEngine.from_csv({
      :items => "./test/data_fixtures/items_fixture.csv",
      :invoices => "./test/data_fixtures/invoices_fixture.csv",
      :transactions => "./test/data_fixtures/transactions_fixture.csv",
      :customers => "./test/data_fixtures/customers_fixture.csv",
      :invoice_items => "./test/data_fixtures/invoice_items_fixture.csv",
    })
  end

  def test_invoice_knows_its_items
    invoice = sales_engine.invoices.find_by_id(1)
    items = invoice.items
    assert_equal 8, items.length
    assert items.any? {|item| item.id == 263519844}
  end
  
end