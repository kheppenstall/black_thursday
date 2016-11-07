module Analytics

  def paid_invoices_by_merchant(merchant)
    merchant.invoices.find_all {|invoice| invoice.is_paid_in_full?}
  end

  def revenue_by_invoices(invoices)
    invoices.reduce(0) {|sum, invoice| sum += invoice.total}
  end

  def merchant_revenue(merchant)
    paid_invoices = paid_invoices_by_merchant(merchant)
    revenue_by_invoices(paid_invoices)
  end

  def revenue_by_merchant(merchant_id)
    merchant = merchant_repository.find_by_id(merchant_id)
    merchant_revenue(merchant)
  end

  def total_revenue_by_date(date)
    invoices = invoice_repository.find_all_by_date(date)
    revenue_by_invoices(invoices)
  end

  def merchants_ranked_by_revenue
    merchant_repository.all.sort_by do |merchant|
      merchant_revenue(merchant)
    end.reverse
  end

  def top_revenue_earners(number = 20)
    merchants_ranked_by_revenue[0..(number - 1)]
  end

  def merchants_with_pending_invoices
    invoices = invoice_repository.all.find_all do |invoice|
      !invoice.is_paid_in_full?
    end
    invoices.map {|invoice| invoice.merchant}.uniq
  end

  def merchants_with_only_one_item
    merchant_repository.all.find_all do |merchant|
      merchant.items.length == 1
    end
  end

  def paid_invoice_items_by_merchant(merchant)
    paid_invoices_by_merchant(merchant).map do |invoice|
      invoice.invoice_items
    end.flatten
  end

  def paid_invoice_items_by_merchant_id(merchant_id)
    merchant = merchant_repository.find_by_id(merchant_id)
    invoice_items = paid_invoice_items_by_merchant(merchant)
  end

  def top_items_from_frequencies(frequencies)
    max_count = frequencies.values.max
    item_ids = frequencies.keys.find_all do |item_id|
      frequencies[item_id] == max_count
    end
    item_repository.all.find_all {|item| item_ids.include?(item.id)}
  end

  def most_sold_item_for_merchant(merchant_id)
    invoice_items = paid_invoice_items_by_merchant_id(merchant_id)
    frequencies = Hash.new(0)
    invoice_items.each do |invoice_item|
      frequencies[invoice_item.item_id] += invoice_item.quantity
    end
    top_items_from_frequencies(frequencies)
  end

  def best_item_for_merchant(merchant_id)
    invoice_items = paid_invoice_items_by_merchant_id(merchant_id)
    item_id = invoice_items.max_by do |invoice_item|
      invoice_item.unit_price * invoice_item.quantity
    end.item_id
    item_repository.find_by_id(item_id)
  end

  def merchants_with_only_one_item_registered_in_month(month)
    merchants = merchant_repository.merchants_registered_in_month(month)
    merchants.find_all {|merchant| merchant.items.length == 1}
  end

end