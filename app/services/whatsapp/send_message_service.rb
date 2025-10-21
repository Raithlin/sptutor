# frozen_string_literal: true

module Whatsapp
  class SendMessageService
    def initialize(contact_submission)
      @contact_submission = contact_submission
    end

    def call
      return unless configured?

      send_message
    rescue StandardError => e
      handle_error(e)
    end

    private

    attr_reader :contact_submission

    def configured?
      twilio_account_sid.present? &&
        twilio_auth_token.present? &&
        twilio_whatsapp_from.present? &&
        whatsapp_recipient.present?
    end

    def send_message
      # TODO: Implement Twilio WhatsApp API integration
      # This is a placeholder that will be implemented when Twilio credentials are configured
      
      # Example implementation:
      # client = Twilio::REST::Client.new(twilio_account_sid, twilio_auth_token)
      # client.messages.create(
      #   from: twilio_whatsapp_from,
      #   to: whatsapp_recipient,
      #   body: message_body
      # )
      
      contact_submission.update!(
        whatsapp_sent: true,
        whatsapp_sent_at: Time.current
      )
    end

    def handle_error(error)
      contact_submission.update!(
        whatsapp_sent: false,
        whatsapp_error: error.message
      )
      Rails.logger.error("WhatsApp send failed: #{error.message}")
    end

    def message_body
      <<~MESSAGE
        New Contact Form Submission

        Name: #{contact_submission.name}
        Email: #{contact_submission.email}
        Phone: #{contact_submission.phone}
        
        Message:
        #{contact_submission.message}
      MESSAGE
    end

    def twilio_account_sid
      ENV['TWILIO_ACCOUNT_SID']
    end

    def twilio_auth_token
      ENV['TWILIO_AUTH_TOKEN']
    end

    def twilio_whatsapp_from
      ENV['TWILIO_WHATSAPP_FROM']
    end

    def whatsapp_recipient
      ENV['WHATSAPP_RECIPIENT']
    end
  end
end
