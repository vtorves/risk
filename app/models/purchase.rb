class Purchase < ApplicationRecord
  enum :status, { none: 0, approve: 1, deny: 2 }, suffix: true

  validates :transaction_id, presence: true
  validates :merchant_id, presence: true
  validates :user_id, presence: true

  validates :card_number, presence: true
  validates :transaction_date, presence: true
  validates :transaction_amount, numericality: { greater_than: 0.1 }
end
