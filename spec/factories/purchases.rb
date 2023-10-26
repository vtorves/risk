FactoryBot.define do
  factory :purchase do
    transaction_id { 1 }
    merchant_id { 1 }
    user_id { 1 }
    card_number { "MyString" }
    transaction_date { "2023-10-26 14:16:25" }
    transaction_amount { "9.99" }
    device_id { 1 }
    has_cbk { false }
    status_updated_at { "2023-10-26 14:16:25" }
  end
end
