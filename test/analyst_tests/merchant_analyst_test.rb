require_relative '../test_helper'
require_relative '../../lib/sales_analyst'

class MerchantAnalystTest < Minitest::Test

  attr_reader :sales_analyst

  def setup
    sales_engine = SalesEngine.from_csv({
      :items => "./test/data_fixtures/items_fixture.csv",
      :merchants => "./test/data_fixtures/merchants_fixture.csv",
      :invoices => "./test/data_fixtures/invoices_fixture.csv"
    })
    @sales_analyst = SalesAnalyst.new(sales_engine)
  end

  def test_calculates_average_items_per_merchant
    assert_equal 0.65, sales_analyst.average_items_per_merchant
  end

  def test_calculates_average_items_per_merchant_standard_deviation
    assert_equal 2.23, sales_analyst.average_items_per_merchant_standard_deviation
  end

  def test_merchants_with_high_item_count_returns_merchants_above_one_st_dev_in_item_count
    top_merchants = sales_analyst.merchants_with_high_item_count
    assert top_merchants.all? {|merchant| merchant.items.length > 2.88}
  end

  def test_average_average_price_per_merchant_returns_average
    average_average_price = sales_analyst.average_average_price_per_merchant
    assert_equal BigDecimal(27.09, 4), average_average_price.round(2)
  end

  def test_calculates_average_invoices_per_merchant
    assert_equal 0.70, sales_analyst.average_invoices_per_merchant
  end

  def test_calculates_standard_deviation_of_average_invoices_per_merchant
     assert_equal 2.90, sales_analyst.average_invoices_per_merchant_standard_deviation
  end

  def test_finds_top_merchants_by_invoice_count
    threshold = 4.30
    merchants = sales_analyst.top_merchants_by_invoice_count
    assert_equal 1, merchants.length
    assert merchants.all? {|merchant| merchant.invoices.length > threshold}
  end

  def test_finds_bottom_merchants_by_invoice_count
    threshold = 0
    merchants = sales_analyst.bottom_merchants_by_invoice_count
    assert_equal 0, merchants.length
    assert merchants.all? {|merchant| merchant.invoices.length < threshold}
  end

end


