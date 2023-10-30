 #== Schema Information
#
# Table name: purchases
#
#  id                 :uuid             not null, primary key
#  transaction_id     :integer          not null
#  merchant_id        :integer          not null
#  user_id            :integer          not null
#  card_number        :string           not null
#  transaction_date   :datetime         not null
#  transaction_amount :decimal(10, 2)   not null
#  device_id          :integer
#  has_cbk            :boolean          default(FALSE)
#  status_updated_at  :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  status             :integer          default("none")
#
class Purchase < ApplicationRecord
  enum :status, { none: 0, approve: 1, deny: 2 }, suffix: true

  validates :transaction_id, presence: true, uniqueness: true
  validates :merchant_id, presence: true, numericality: { only_integer: true }
  validates :user_id, presence: true, numericality: { only_integer: true }

  validates :card_number, presence: true,
    format: { with: /\A\d{6}\*+\d{4}\z|\A\d{6}\*+\d{5}\z/,
      message: "must match the format '######******####' with either 15 or 16 digits" }

  validates :transaction_date, presence: true
  validates :transaction_amount, presence: true,
                                 numericality: { greater_than: 0.0 }
  validate :transaction_date_validity

  scope :have_previous_transaction?, lambda { |user_id, card_number, merchant_id, transaction_amount|
    where(
      user_id: user_id,
      card_number: card_number,
      merchant_id: merchant_id,
      transaction_amount: transaction_amount
    )
  }

  scope :has_chargeback?, lambda { |user_id|
    where(
      user_id: user_id,
      has_cbk: true
    )
  }

  scope :sum_transactions, lambda { |user_id, transaction_amount|
    where(
      user_id: user_id,
      transaction_amount: transaction_amount,
      created_at: 1.week.hour.ago..Time.zone.now
    )
      .sum(:transaction_amount)
  }

  def transaction_date_validity
    return if transaction_date.present?

    begin
      if transaction_date.present? && transaction_date > Time.zone.now
        errors.add(:transaction_date, 'must be in the past')
      end
    rescue ArgumentError
      errors.add(:transaction_date, 'is not a valid datetime')
    end
  end
end
