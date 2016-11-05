require 'time'

class Invoice

  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at,
              :parent

  def initialize(data, parent = nil)
      @id = data[:id].to_i
      @customer_id = data[:customer_id].to_i
      @merchant_id = data[:merchant_id].to_i
      @status = data[:status].to_sym
      @created_at = Time.parse(data[:created_at])
      @updated_at = Time.parse(data[:updated_at])
      @parent = parent
  end

  def merchant
    parent.find_merchant(merchant_id)
  end

  def items
    parent.find_items(id)
  end

  def transactions
    parent.find_transactions(id)
  end

  def customer
    parent.find_customer(customer_id)
  end

  def successful_transactions?
    transactions.all? {|transaction| transaction.result == "success"}
  end

  def is_paid_in_full?
    successful_transactions? && !transactions.empty?
  end

  def total
    if is_paid_in_full?
      items.reduce(0) {|total, item| total += item.unit_price}.round(2)
    end
  end

end