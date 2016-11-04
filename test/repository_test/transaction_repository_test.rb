require_relative '../test_helper'
require_relative '../../lib/transaction_repository'

class TransactionRepositoryTest < Minitest::Test

	attr_reader :transaction_repository

	def setup
		file = "./test/data_fixtures/transactions_fixture.csv"
    @transaction_repository = TransactionRepository.new(file, Minitest::Mock.new)
  end

  def test_transaction_repo_exists
  	assert transaction_repository
  end

  def test_all_returns_an_array
  	assert_kind_of Array, transaction_repository.all
  end

  def test_all_returns_an_array_of_all_transaction_objects
  	transaction_repository.all.all? {|transaction| assert_kind_of Transaction, transaction}
  end

  def test_all_includes_all_transactions
  	assert_equal 37, transaction_repository.all.length
  end

  def test_find_by_id_finds_transaction_with_matching_id
  	transaction = transaction_repository.find_by_id(7)
    assert_equal 1298, transaction.invoice_id
  end

  def test_find_by_id_returns_nil_when_there_is_no_transaction_matching_id
    assert_nil transaction_repository.find_by_id(999999999)
  end

  def test_find_all_by_invoice_id_returns_array_with_one_invoice
    transaction = transaction_repository.find_all_by_invoice_id(2179)
    assert_equal 1, transaction.length
    assert_equal 1, transaction.first.id
  end

  def test_find_all_by_invoice_id_returns_all_matching_invoice_ids
    transactions = transaction_repository.find_all_by_invoice_id(3477)
    assert_equal 2, transactions.length
  end

  def test_find_all_by_invoice_id_returns_empty_array_for_invoice_id_with_no_matches
    transactions = transaction_repository.find_all_by_invoice_id(999999999)
    assert_equal [], transactions
  end

  def test_find_all_by_credit_card_number_returns_array_with_one_matching_cc_number
    transaction = transaction_repository.find_all_by_credit_card_number(4890371279632775)
    assert_equal 1, transaction.length
    assert_equal 20, transaction.first.id
  end

  def test_find_all_by_credit_card_number_returns_empty_array_when_there_are_no_matches
    transactions = transaction_repository.find_all_by_credit_card_number(9999999999999999)
    assert_equal [], transactions
  end

  def test_find_all_by_credit_card_number_returns_array_with_all_cc_number_matches
    transactions = transaction_repository.find_all_by_credit_card_number(4055564081112246)
    assert_equal 2, transactions.length
  end

  def test_find_all_by_result_finds_all_successful_transactions
    transactions = transaction_repository.find_all_by_result("success")
    assert_equal 31, transactions.length
  end

  def test_find_all_by_result_finds_all_failed_transactions
  	transactions = transaction_repository.find_all_by_result("failed")
  	assert_equal 6, transactions.length
  end

  def test_find_all_by_result_without_match_returns_empty_array
  	transactions = transaction_repository.find_all_by_result("declined")
  	assert_equal [], transactions
  end

  def test_transaction_repo_knows_its_parent
    transaction_repository.parent.expect(:find_invoice_by_invoice_id, nil, [3333])
    transaction_repository.find_invoice(3333)
    transaction_repository.parent.verify
  end

  def test_inspect_returns_class_and_size
    inspection = "#<TransactionRepository 37 rows>"
    assert_equal inspection, transaction_repository.inspect
  end

end