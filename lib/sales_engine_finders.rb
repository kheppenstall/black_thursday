module SalesEngineFinders

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

  def find_invoice_items_by_invoice_id(invoice_id)
    invoice_items.find_all_by_invoice_id(invoice_id)
  end

  def find_invoice_by_invoice_id(invoice_id)
    invoices.find_by_id(invoice_id)
  end

  def find_transactions_by_invoice_id(invoice_id)
    transactions.find_all_by_invoice_id(invoice_id)
  end

  def find_customer_by_customer_id(customer_id)
    customers.find_by_id(customer_id)
  end

  def find_items_by_invoice_id(invoice_id)
    invoice_items = find_invoice_items_by_invoice_id(invoice_id)
    item_ids = invoice_items.map {|invoice_item| invoice_item.item_id}
    item_ids.map {|item_id| items.find_by_id(item_id)}
  end

end