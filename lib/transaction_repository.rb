require_relative 'transaction'
require_relative 'csv_parser'

class TransactionRepository

  include CSV_parser

  attr_reader :all,
              :parent

  def initialize(file, parent = nil)
    exp_date = :credit_card_expiration_date
    @all = parse(file).map do |row|
      Transaction.new({:id => row[:id],
                :invoice_id => row[:invoice_id],
                :credit_card_number => row[:credit_card_number],
                :credit_card_expiration_date => row[exp_date],
                :result => row[:result],
                :created_at => row[:created_at],
                :updated_at => row[:updated_at]},
                self)
    end
    @parent = parent
  end

  def find_by_id(id)
    all.find {|transaction| transaction.id == id}
  end

  def find_all_by_invoice_id(invoice_id)
    all.find_all {|transaction| transaction.invoice_id == invoice_id}
  end

  def find_all_by_credit_card_number(number)
    all.find_all {|transaction| transaction.credit_card_number == number}
  end

  def find_all_by_result(result)
    all.find_all {|transaction| transaction.result == result}
  end

  def find_invoice(invoice_id)
    parent.find_invoice_by_invoice_id(invoice_id)
  end

  def inspect
    "#<#{self.class} #{@all.size} rows>"
  end

end