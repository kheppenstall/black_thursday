require_relative 'merchant_repository'
require_relative 'item_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'

class SalesEngine

  attr_reader :merchants,
              :items,
              :invoices,
              :invoice_items

  def self.from_csv(files)
    new(files)
  end

  def initialize(files)
    @merchants = create_merchant_repository(files)
    @items = create_item_repository(files)
    @invoices= create_invoice_repository(files)
    @invoice_items = create_invoice_item_repository(files)
  end

  def create_invoice_item_repository(files)
    if files.include?(:invoice_items)
      InvoiceItemRepository.new(files[:invoice_items])
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

  def find_by_merchant_id(merchant_id)
    merchants.find_by_id(merchant_id)
  end

  def find_invoices_by_merchant_id(merchant_id)
    invoices.find_all_by_merchant_id(merchant_id)
  end

  def find_items_by_merchant_id(merchant_id)
    items.find_all_by_merchant_id(merchant_id)
  end

end