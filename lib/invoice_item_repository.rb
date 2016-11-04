require_relative 'invoice_item'
require_relative 'csv_parser'

class InvoiceItemRepository

  include CSV_parser

  attr_reader :all,
              :parent

  def initialize(file, parent = nil)
    @all = parse(file).map do |row|
      InvoiceItem.new({ :id          => row[:id],
                    :item_id     => row[:item_id],
                    :invoice_id  => row[:invoice_id],
                    :quantity    => row[:quantity],
                    :unit_price  => row[:unit_price],
                    :created_at  => row[:created_at],
                    :updated_at  => row[:updated_at]},
                    self)
    end
    @parent = parent
  end

  def find_by_id(id)
    all.find {|invoice_item| invoice_item.id == id}
  end

  def find_all_by_item_id(item_id)
    all.find_all {|invoice_item| invoice_item.item_id == item_id}
  end

  def find_all_by_invoice_id(invoice_id)
    all.find_all {|invoice_item| invoice_item.invoice_id == invoice_id}
  end

  def find_items(item_id)
    parent.find_items_by_item_id(item_id)
  end

  def inspect
    "#<#{self.class} #{@all.size} rows>"
  end

end