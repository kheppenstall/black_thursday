require_relative '../test_helper'
require_relative '../../lib/sales_analyst'

class AnalyticsTest < Minitest::Test

  attr_reader :sales_analyst

  def setup
    sales_engine = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :merchants => "./data/merchants.csv",
      :transactions => "./data/transactions.csv",
      :customers => "./data/customers.csv"
    })
    @sales_analyst = SalesAnalyst.new(sales_engine)
  end

  def test_revenue_by_merchant_returns_revenue_from_merchant
    revenue = sales_analyst.revenue_by_merchant(12334194)
    assert_equal 81572.4, revenue.to_f
  end

  def test_total_revenue_by_date_gives_revenue_from_date
    date = Time.parse("2009-02-07")
    revenue = sales_analyst.total_revenue_by_date(date)
    assert_equal 21067.77, revenue
  end

  def test_top_revenue_earners_of_1_gives_earner
    merchants = sales_analyst.top_revenue_earners(10)
    assert_equal 10, merchants.length
    assert_equal 12334634, merchants.first.id
    assert_equal 12335747, merchants.last.id
  end

  def test_top_revenue_earners_gives_20_by_default
    merchants = sales_analyst.top_revenue_earners
    assert_equal 20, merchants.length
    assert_equal 12334634, merchants.first.id
    assert_equal 12334159, merchants.last.id
  end

  def test_merchants_with_pending_invoices
    merchants = sales_analyst.merchants_with_pending_invoices
    assert_equal 467, merchants.length
    assert merchants.all? do |merchant|
      merchant.invoices.any? {|invoice| invoice.status == :pending}
    end
  end

  def test_merchants_with_only_one_item
    merchants = sales_analyst.merchants_with_only_one_item
    assert_equal 243, merchants.length
    assert merchants.all? {|merchant| merchant.items.length == 1}
  end

  def test_most_sold_item_for_merchant
    items = sales_analyst.most_sold_item_for_merchant(12334189)
    assert_equal 1, items.length
    assert_equal 263524984, items.first.id
  end

  def test_most_sold_items_for_merchant
    items = sales_analyst.most_sold_item_for_merchant(12337105)
    assert_equal 4, items.length
  end

  def test_best_item_for_merchant_by_revenue
    item = sales_analyst.best_item_for_merchant(12334189)
    assert_equal 263516130, item.id
  end

  def test_best_item_for_different_merchant_by_revenue
    item = sales_analyst.best_item_for_merchant(12337105)
    assert_equal 263463003, item.id
  end

  def test_merchants_with_only_one_item_registered_in_march_returns_merchants
    month = "March"
    merchants = sales_analyst.merchants_with_only_one_item_registered_in_month(month)
    assert_equal 21, merchants.length
  end

  def test_merchants_with_only_one_item_registered_in_june_returns_merchants
    month = "June"
    merchants = sales_analyst.merchants_with_only_one_item_registered_in_month(month)
    assert_equal 18, merchants.length
  end

end