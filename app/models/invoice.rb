class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :discounts, through: :merchants

  enum status: [:cancelled, 'in progress', :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_discounted_revenue
    a = self.invoice_items.joins(item: [merchant: :discounts]).where('quantity_threshold <= quantity').group(:id).select('invoice_items.*, (100 - max(percent_discount)) * 0.01 as best_discount')

    discounted_items_price = a.map{|row| row.quantity * row.unit_price * row.best_discount}.sum
    undiscounted_items_price = self.invoice_items.joins(item: [merchant: :discounts]).where('? > quantity', self.discounts.minimum(:quantity_threshold)).group(:id).sum('quantity * items.unit_price')

    discounted_items_price + undiscounted_items_price.values.sum
  end
end