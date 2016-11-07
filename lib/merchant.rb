class Merchant

  attr_reader :id,
              :name,
              :parent,
              :created_at

  def initialize(data, parent = nil)
    @id = data[:id].to_i
    @name = data[:name]
    @created_at = Time.parse(data[:created_at])
    @parent = parent
  end

  def items
    parent.find_items(id)
  end

  def invoices
    parent.find_invoices(id)
  end

  def customers
    parent.find_customers(id)
  end

end