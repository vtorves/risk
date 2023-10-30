module RiskManager
  class Checker < ApplicationService
    def initialize(check_params)
      @check_params = check_params
    end

    def call
      is_validate_params = validate_params
      if is_validate_params
        validate_on_main_rules?
      else
        validate_params
      end
    end

    def validate_params
      purchase = Purchase.new(@check_params)
      return true if purchase.valid?

      error_message = purchase.errors.full_messages.join(', ').to_s
      raise InvalidCheckerError.new(error_message)
    end

    private

    def validate_on_main_rules?
      return deny_format_answer if limit_exceded?
      return deny_format_answer if user_has_chargeback?
      return deny_format_answer if transactions_with_same_value?

      approved_format_answer
    end

    def limit_exceded?
      Purchase.sum_transactions(@check_params[:user_id], @check_params[:transaction_id]) > Rules::LIMIT_PER_HOUR
    end

    def user_has_chargeback?
      Purchase.has_chargeback?(@check_params[:user_id]).exists?
    end

    def transactions_with_same_value?
      Purchase.have_previous_transaction?(
        @check_params[:user_id],
        @check_params[:card_number],
        @check_params[:merchant_id],
        @check_params[:transaction_amount]
      ).exists?
    end

    def deny_format_answer
      FormatAnswer.call(
        Status::DENY,
        { transaction_id: @check_params['transaction_id'] }
      )
    end

    def approved_format_answer
      FormatAnswer.call(
        Status::APPROVE,
        { transaction_id: @check_params['transaction_id'] }
      )
    end
  end
end
