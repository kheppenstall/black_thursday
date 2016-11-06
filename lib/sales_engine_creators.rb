module SalesEngineCreators

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

end