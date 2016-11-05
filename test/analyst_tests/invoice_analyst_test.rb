require_relative '../test_helper'
require_relative '../../lib/sales_analyst'

class InvoiceAnalystTest < Minitest::Test

  attr_reader :sales_analyst

  def setup
    sales_engine = SalesEngine.from_csv({
      :invoices => "./test/data_fixtures/invoices_fixture.csv"
    })
    @sales_analyst = SalesAnalyst.new(sales_engine)
  end

  def test_percentage_of_invoices_pending
    assert_equal 35.71, sales_analyst.invoice_status(:pending)
  end

  def test_percentage_of_invoices_shipped
    assert_equal 53.57, sales_analyst.invoice_status(:shipped)
  end

  def test_percentage_of_invoices_returned
    assert_equal 10.71, sales_analyst.invoice_status(:returned)
  end

  def test_top_days_by_invoice_count_returns_days_two_standard_deviations_above_mean
    assert_equal ['Friday'], sales_analyst.top_days_by_invoice_count
  end

end