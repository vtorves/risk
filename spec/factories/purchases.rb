# == Schema Information
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
FactoryBot.define do
  factory :purchase do
    sequence(:transaction_id) { |n| "234_235_74#{n}" }
    merchant_id { 297_444 }
    user_id { 970_514 }
    card_number { '434505******9115' }
    transaction_date { '2019-11-30T23:16:32.812631' }
    transaction_amount { 3734.0 }
    device_id { 285_475 }
    status { 0 }
    created_at { Time.zone.now - 30.days }
    updated_at { Time.zone.now - 30.days }
    has_cbk { false }

    trait :with_cbk do
      has_cbk { true }
    end
  end
end
