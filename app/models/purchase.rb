class Purchase < ApplicationRecord
  enum :status, { none: 0, approve: 1, deny: 2 }, suffix: true

  validates :transaction_id, presence: true
  validates :merchant_id, presence: true
  validates :user_id, presence: true

  validates :card_number, presence: true
  validates :transaction_date, presence: true
  validates :transaction_amount, numericality: { greater_than: 0.1 }

  scope :has_chargeback?, -> { where(has_cbk: true) }

  scope :have_previous_transaction?, ->(params) {
    where(
      transaction_id: params[:transaction_id],
      merchant_id: params[:merchant_id],
      user_id: params[:user_id],
      card_number: params[:card_number],
      transaction_amount: params[:transaction_amount]
    )
  }

  scope :has_chargeback?, -> { where(has_cbk: true) }

  scope :sum_transactions, ->(params) {
    where(
      user_id: params[:user_id],
      transaction_amount: params[:transaction_amount],
      created_at: 1.week.hour.ago..Time.now.utc
    )
      .sum(:transaction_amount)
  }
end
