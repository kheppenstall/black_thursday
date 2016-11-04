require_relative 'customer'
require_relative 'csv_parser'

class CustomerRepository

  include CSV_parser

  attr_reader :all,
              :parent

  def initialize(parent = nil)
    @parent = parent
    @all = []
  end

  def from_csv(file)
    @all = parse(file).map do |row|
      Customer.new({:id           => row[:id],
                    :first_name   => row[:first_name],
                    :last_name    => row[:last_name],
                    :created_at   => row[:created_at],
                    :updated_at   => row[:updated_at]
                    })
    end
  end

  def find_by_id(id)
    all.find {|customer| customer.id == id}
  end

  def find_all_by_first_name(first_name)
    all.find_all do |customer|
      customer.first_name.downcase.include?(first_name.downcase)
    end
  end

  def find_all_by_last_name(last_name)
    all.find_all do |customer|
      customer.last_name.downcase.include?(last_name.downcase)
    end
  end

  def find_merchants(customer_id)
    parent.find_merchants_by_customer_id(customer_id)
  end

  def inspect
    "#<#{self.class} #{@all.size} rows>"
  end

end