class Api::V1::PurchasesController < ApplicationController

  def create
    checker = RiskManager::Checker.call(permitted_params)

    if checker[:recommendation] == :approve
      render json: checker, status: :accepted
    else
      render json: checker, status: :payment_required
    end
  end

  private

  def permitted_params
    params.permit(
      :transaction_id,
      :merchant_id,
      :user_id,
      :card_number,
      :transaction_date,
      :transaction_amount,
      :device_id
    )
  end
end
