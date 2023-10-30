# == Schema Information
#
#
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
require 'rails_helper'

RSpec.describe Purchase, type: :model do
  let(:purchase) { FactoryBot.build(:purchase) }

  it { should define_enum_for(:status).with_values(none: 0, approve: 1, deny: 2).with_suffix(true) }
  it { should validate_presence_of(:transaction_id) }
  it { should validate_presence_of(:merchant_id) }
  it { should validate_numericality_of(:merchant_id).only_integer }
  it { should validate_presence_of(:user_id) }
  it { should validate_numericality_of(:user_id).only_integer }
  it { should validate_presence_of(:card_number) }
  it { should allow_value('434505******9115').for(:card_number) }
  it { should_not allow_value('123456******12345991').for(:card_number) }
  it { should_not allow_value('123456').for(:card_number) }

  it { should validate_presence_of(:transaction_date) }
  it { should validate_numericality_of(:transaction_amount).is_greater_than(0.0) }

  describe 'scopes' do

    it 'has_chargeback? returns purchases with has_cbk: true' do
      params = { transaction_id: 444, user_id: 444, has_cbk: true }
      create(:purchase, params)
      create(:purchase)
expect(binding.pry)
      expect(Purchase.has_chargeback?(444).count).to eq(1)
    end

    it 'have_previous_transaction? filters purchases with specified parameters' do
      params = {
        transaction_id: 1234,
        merchant_id: 456,
        user_id: 789,
        card_number: '123456******1234',
        transaction_amount: 100.0
      }

      FactoryBot.create(:purchase, params)
      FactoryBot.create(:purchase)
      expect(Purchase.have_previous_transaction?(params[:user_id], params[:card_number], params[:merchant_id], params[:transaction_amount]).count).to eq(1)
      expect(Purchase.count).to eq(2)
    end
    it 'sum_transactions returns the sum of transaction amounts within a time range' do
      user_id = 1
      transaction_amount = 50.0
      create(:purchase, user_id: user_id, transaction_amount: transaction_amount, created_at: 2.days.ago)
      create(:purchase, user_id: user_id, transaction_amount: transaction_amount, created_at: 1.day.ago)
      create(:purchase, user_id: user_id, transaction_amount: transaction_amount, created_at: Time.zone.now)

      params = {
        user_id: user_id,
        transaction_amount: transaction_amount
      }

      sum = Purchase.sum_transactions(params[:user_id], params[:transaction_amount])

      expect(sum).to eq(150.0)
    end
  end
end
