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

    def validate_on_main_rules?
      limit_exceded = Purchase.sum_transactions(@check_params) > 1000

      return deny_format_answer if limit_exceded
      return deny_format_answer if Purchase.has_chargeback?.exists?
      return deny_format_answer if Purchase.have_previous_transaction?(@check_params).exists?

      approved_format_answer
    end

    def deny_format_answer
      FormatAnswer.call(
        RiskManager::Status::DENY,
        { transaction_id: @check_params['transaction_id'] }
      )
    end

    def approved_format_answer
      FormatAnswer.call(
        RiskManager::Status::APPROVE,
        { transaction_id: @check_params['transaction_id'] }
      )
    end
  end
end
