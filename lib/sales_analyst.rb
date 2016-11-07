require_relative 'sales_engine'
require_relative 'item_analyst'
require_relative 'merchant_analyst'
require_relative 'invoice_analyst'
require_relative 'analytics'
require_relative 'calculator'

class SalesAnalyst

  include ItemAnalyst
  include MerchantAnalyst
  include InvoiceAnalyst
  include Analytics
  include Calculator

  attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def merchant_repository
    sales_engine.merchants
  end

  def merchants
    merchant_repository.all
  end

  def invoice_repository
    sales_engine.invoices
  end

  def invoices
    invoice_repository.all
  end

  def total_invoice_count
    invoices.length
  end

  def item_repository
    sales_engine.items
  end

  def items
    item_repository.all
  end

  def item_count(merchant)
    merchant.items.length
  end

  def days_of_the_week
    {"Sunday" => 0,
     "Monday" => 1,
     "Tuesday" => 2,
     "Wednesday" => 3,
     "Thursday" => 4,
     "Friday" => 5,
     "Saturday" => 6
    }
  end

end