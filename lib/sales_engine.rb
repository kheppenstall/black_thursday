require_relative 'merchant_repository'
require_relative 'item_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'
require_relative 'customer_repository'
require_relative 'transaction_repository'

class SalesEngine

  attr_reader :merchants,
              :items,
              :invoices,
              :invoice_items,
              :customers,
              :transactions

  def self.from_csv(files)
    new(files)
  end

  def initialize(files)
    @merchants = create_merchant_repository(files)
    @items = create_item_repository(files)
    @invoices = create_invoice_repository(files)
    @invoice_items = create_invoice_item_repository(files)
    @customers = create_customer_repository(files)
    @transactions = create_transaction_repository(files)
  end

  def create_transaction_repository(files)
    if files.include?(:transactions)
      TransactionRepository.new(files[:transactions], self)
    end
  end

  def create_invoice_item_repository(files)
    if files.include?(:invoice_items)
      InvoiceItemRepository.new(files[:invoice_items], self)
    end
  end

  def create_customer_repository(files)
    if files.include?(:customers)
      CustomerRepository.new(files[:customers], self)
    end
  end

  def create_item_repository(files)
    if files.include?(:items)
      ItemRepository.new(files[:items], self)
    end
  end

  def create_merchant_repository(files)
    if files.include?(:merchants)
      MerchantRepository.new(files[:merchants], self)
    end
  end

  def create_invoice_repository(files)
    if files.include?(:invoices)
      InvoiceRepository.new(files[:invoices], self)
    end
  end

  def find_merchant_by_merchant_id(merchant_id)
    merchants.find_by_id(merchant_id)
  end

  def find_invoices_by_merchant_id(merchant_id)
    invoices.find_all_by_merchant_id(merchant_id)
  end

  def find_invoices_by_customer_id(customer_id)
    invoices.find_all_by_customer_id(customer_id)
  end

  def find_items_by_merchant_id(merchant_id)
    items.find_all_by_merchant_id(merchant_id)
  end

  def find_customers_by_merchant_id(merchant_id)
    invoices = find_invoices_by_merchant_id(merchant_id)
    customer_ids = invoices.map {|invoice| invoice.customer_id}
    customer_ids.map {|customer_id| customers.find_by_id(customer_id)}.uniq
  end

  def find_merchants_by_customer_id(customer_id)
    invoices = find_invoices_by_customer_id(customer_id)
    merchant_ids = invoices.map {|invoice| invoice.merchant_id}
    merchant_ids.map {|merchant_id| merchants.find_by_id(merchant_id)}
  end

end