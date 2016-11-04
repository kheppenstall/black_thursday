require_relative '../test_helper'
require_relative '../../lib/invoice_item_repository'

class InvoiceItemRepositoryTest < Minitest::Test

  attr_reader :invoice_item_repository

  def setup
    file = "./test/data_fixtures/invoice_items_fixture.csv"
    @invoice_item_repository = InvoiceItemRepository.new(file, Minitest::Mock.new)
  end

  def test_invoice_item_repo_exists
    assert invoice_item_repository
  end

  def test_all_returns_an_array
    assert_kind_of Array, invoice_item_repository.all
  end

  def test_all_returns_an_array_of_all_invoice_item_objects
    invoice_item_repository.all.all? {|invoice_item| assert_kind_of InvoiceItem, invoice_item}
  end

  def test_all_includes_all_invoices_items
    assert_equal 45, invoice_item_repository.all.length
  end

  def test_find_by_id_finds_invoice_item_with_matching_id
    id = 1
    invoice_item = invoice_item_repository.find_by_id(id)
    assert_equal 263519844, invoice_item.item_id
  end

  def test_find_by_id_returns_nil_when_no_id_matches
    id = 9999999
    invoice_item = invoice_item_repository.find_by_id(id)
    assert_nil invoice_item
  end

  def test_find_all_by_item_id_returns_invoice
    item_id = 263519844
    invoice_items = invoice_item_repository.find_all_by_item_id(item_id)
    assert_equal 1, invoice_items.length
    assert_equal 1, invoice_items.first.id
  end

  def test_find_all_by_item_id_returns_empty_array_when_there_are_no_matches
    item_id = 9999999999999
    invoice_items = invoice_item_repository.find_all_by_item_id(item_id)
    assert_equal [], invoice_items
  end

  def test_find_all_by_invoice_id_finds_all_invoice_items
    invoice_id = 1
    invoice_items = invoice_item_repository.find_all_by_invoice_id(invoice_id)
    assert_equal 8, invoice_items.length
    invoice_items.all? {|invoice_item| invoice_item.invoice_id == 1}
  end

  def test_find_all_by_invoice_id_returns_nil_for_id_with_no_matches
    invoice_id = 9999999999999
    invoice_items = invoice_item_repository.find_all_by_invoice_id(invoice_id)
    assert_equal [], invoice_items
  end

  def test_inspect_returns_only_class_and_size
    inspection = invoice_item_repository.inspect
    assert_equal "#<InvoiceItemRepository 45 rows>", inspection
  end

  def test_invoice_item_repo_knows_its_parent
    invoice_item_repository.parent.expect(:find_items_by_item_id, nil, [3333])
    invoice_item_repository.find_items(3333)
    invoice_item_repository.parent.verify
  end

end