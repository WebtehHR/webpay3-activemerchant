class Order < ActiveRecord::Base

  CURRENCIES = ['USD', 'EUR', 'HRK']
  STATUSES = ['Pending', 'Approved', 'Declined']

  validates :order_number, :currency, :amount, :status, presence: true
  validates :order_number, uniqueness: true
  validates :currency, inclusion: { in: CURRENCIES }
  validates :status, inclusion: { in: STATUSES }
  validates :amount, numericality: { only_integer: true }

end
