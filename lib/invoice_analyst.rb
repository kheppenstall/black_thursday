module InvoiceAnalyst

  def invoice_repo
    sales_engine.invoices
  end
  
  def invoices
    invoice_repo.all
  end
  
  def total_invoice_count
    invoices.length
  end
  
  def invoice_status(status)
    invoices_of_status = invoice_repo.find_all_by_status(status)
    status_count = invoices_of_status.length
    percentage(status_count, total_invoice_count).round(2).to_f
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

  def invoice_days(invoice_days_nums)
    invoice_days = Hash.new
    days_of_the_week.keys.each do |day|
      invoice_days[day] = invoice_days_nums.count(days_of_the_week[day])
    end
    invoice_days
  end

  def threshold(invoice_day_counts)
    standard_deviation = standard_deviation(invoice_day_counts)
    average = average(invoice_day_counts)
    average + standard_deviation
  end
  
  def top_days_by_invoice_count
    invoice_days_nums = invoices.map {|invoice| invoice.created_at.wday}
    invoice_days = invoice_days(invoice_days_nums)
    threshold = threshold(invoice_days.values)
    invoice_days.keys.find_all{|day| invoice_days[day] > threshold}
  end

end