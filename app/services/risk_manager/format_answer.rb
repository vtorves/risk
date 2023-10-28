module RiskManager
  class FormatAnswer < ApplicationService
    def initialize(status, opt = {})
      @status = status
      @transaction_id = opt[:transaction_id]
      @message = opt[:message]
    end

    def call
      case @status
      when RiskManager::Status::APPROVE
        approved
      when RiskManager::Status::DENY
        deny
      else
        generic_error
      end
    end

    private

    def approved
      {
        transaction_id: @transaction_id,
        recommendation: :approve
      }
    end

    def deny
      {
        transaction_id: @transaction_id,
        recommendation: :deny
      }
    end

    def generic_error
      {
        transaction_id: @transaction_id,
        message: 'undefined error'
      }
    end
  end
end
