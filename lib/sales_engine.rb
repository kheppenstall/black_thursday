require_relative 'merchant_repository'
require_relative 'item_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'
require_relative 'customer_repository'
require_relative 'transaction_repository'
require_relative 'sales_engine_finders'
require_relative 'sales_engine_creators'

class SalesEngine

  include SalesEngineFinders
  include SalesEngineCreators

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

end