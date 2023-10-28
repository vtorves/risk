class Purchase < ApplicationRecord
  enum :status, { none: 0, approve: 1, deny: 2 }, suffix: true

  validates :transaction_id, presence: true#, uniqueness: true
  validates :merchant_id, presence: true, numericality: { only_integer: true }
  validates :user_id, presence: true, numericality: { only_integer: true }

  validates :card_number, presence: true,
                          format: { with: /\A\d{6}\*+\d{4}\z/, message: "must match the format '######******####'" }

  validates :transaction_date, presence: true
  validates :transaction_amount, presence: true,
                                 numericality: { greater_than: 0.0 }
  validate :transaction_date_validity

  scope :has_chargeback?, -> { where(has_cbk: true) }

  scope :have_previous_transaction?, lambda { |params|
    where(
      transaction_id: params[:transaction_id],
      merchant_id: params[:merchant_id],
      user_id: params[:user_id],
      card_number: params[:card_number],
      transaction_amount: params[:transaction_amount]
    )
  }

  scope :has_chargeback?, -> { where(has_cbk: true) }

  scope :sum_transactions, lambda { |params|
    where(
      user_id: params[:user_id],
      transaction_amount: params[:transaction_amount],
      created_at: 1.week.hour.ago..Time.zone.now
    )
      .sum(:transaction_amount)
  }

  def transaction_date_validity
    return if transaction_date.present?

    begin
      if transaction_date > Time.zone.now
        errors.add(:transaction_date, 'must be in the past')
      end
    rescue ArgumentError
      errors.add(:transaction_date, 'is not a valid datetime')
    end
  end
end
