FactoryBot.define do
  factory :purchase do
    transaction_id { 234_235_7 }
    merchant_id { 297_44 }
    user_id { 970_51 }
    card_number { '434505******9116' }
    transaction_date { '2019-11-31T23:16:32.812632' }
    transaction_amount { '373' }
    device_id { 285_475 }
    status { 0 }
  end
end
