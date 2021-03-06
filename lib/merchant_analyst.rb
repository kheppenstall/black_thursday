module MerchantAnalyst

  def merchant_item_counts
    merchants.map {|merchant| BigDecimal(item_count(merchant))}
  end

  def average_items_per_merchant
    average(merchant_item_counts).round(2).to_f
  end

  def average_items_per_merchant_standard_deviation
    standard_deviation(merchant_item_counts).round(2).to_f
  end

  def merchants_with_high_item_count
    standard_deviation = average_items_per_merchant_standard_deviation
    threshold = average_items_per_merchant + standard_deviation
    merchants.find_all {|merchant| item_count(merchant) > threshold}
  end

  def average_item_price_for_merchant(merchant_id)
    merchant = sales_engine.merchants.find_by_id(merchant_id)
    set = merchant.items.map {|item| item.unit_price}
    average(set).round(2)
  end

  def average_average_price_per_merchant
    set = merchants.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end
    average(set).round(2)
  end

  def invoice_count(merchant)
    BigDecimal(merchant.invoices.length)
  end

  def average_invoices_per_merchant
    average(merchant_invoice_count).round(2).to_f
  end

  def merchant_invoice_count
    merchants.map {|merchant| invoice_count(merchant)}
  end

  def average_invoices_per_merchant_standard_deviation
    standard_deviation(merchant_invoice_count).round(2).to_f
  end

  def invoice_threshold(multiplier)
    standard_deviation = average_invoices_per_merchant_standard_deviation
    average_invoices_per_merchant + standard_deviation * multiplier
  end

  def top_merchants_by_invoice_count
    threshold = invoice_threshold(2)
    merchants.find_all {|merchant| invoice_count(merchant) > threshold}
  end

  def bottom_merchants_by_invoice_count
    threshold = invoice_threshold(-2)
    merchants.find_all {|merchant| invoice_count(merchant) < threshold}
  end

end


