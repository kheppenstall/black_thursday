require_relative 'test_helper'
require_relative '../lib/invoice_item'

class InvoiceItemTest < Minitest::Test

  attr_reader :invoice_item

  def setup
    @invoice_item = InvoiceItem.new({
      :id             => "6",
      :item_id        => "7",
      :invoice_id     => "8",
      :quantity       => "1",
      :unit_price     => "1099",
      :created_at     => Time.now.to_s,
      :updated_at     => Time.now.to_s},
      Minitest::Mock.new)
  end

  def test_invoice_item_exists
    assert invoice_item
  end

  def test_invoice_item_knows_its_id
    assert_equal 6, invoice_item.id
  end

  def test_invoice_item_knows_its_item_id
    assert_equal 7, invoice_item.item_id
  end

  def test_invoice_item_knows_its_invoice_id
    assert_equal 8, invoice_item.invoice_id
  end

  def test_invoice_item_knows_unit_price
    assert_equal BigDecimal.new(10.99,4), invoice_item.unit_price
  end

  def test_invoice_item_knows_time_created_at
    assert_equal Time.now.to_s, invoice_item.created_at.to_s
  end

  def test_invoice_item_knows_time_updated_at
    assert_equal Time.now.to_s, invoice_item.updated_at.to_s
  end

  def test_unit_price_to_dollars_returns_float_of_price
    assert_equal 10.99, invoice_item.unit_price_to_dollars
  end

  def test_invoice_item_calls_parent
    invoice_item.parent.expect(:find_items, nil, [7])
    invoice_item.items
    invoice_item.parent.verify
  end

end