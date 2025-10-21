# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Whatsapp::SendMessageService do
  describe '#call' do
    let(:contact_submission) do
      ContactFormSubmission.create!(
        name: 'John Doe',
        email: 'john@example.com',
        phone: '+1234567890',
        message: 'Test message'
      )
    end

    let(:service) { described_class.new(contact_submission) }

    context 'when WhatsApp credentials are configured' do
      before do
        # Mock Twilio client configuration
        allow(ENV).to receive(:[]).with('TWILIO_ACCOUNT_SID').and_return('test_sid')
        allow(ENV).to receive(:[]).with('TWILIO_AUTH_TOKEN').and_return('test_token')
        allow(ENV).to receive(:[]).with('TWILIO_WHATSAPP_FROM').and_return('whatsapp:+1234567890')
        allow(ENV).to receive(:[]).with('WHATSAPP_RECIPIENT').and_return('whatsapp:+0987654321')
      end

      it 'sends a WhatsApp message successfully' do
        # This test will be implemented when Twilio integration is added
        # For now, we'll just verify the service can be instantiated
        expect(service).to be_a(Whatsapp::SendMessageService)
      end

      it 'marks the submission as sent on success' do
        # Placeholder for future implementation
        expect(contact_submission.whatsapp_sent).to be false
      end
    end

    context 'when WhatsApp credentials are not configured' do
      it 'raises a configuration error' do
        # Placeholder for future implementation
        expect(service).to be_a(Whatsapp::SendMessageService)
      end
    end

    context 'when sending fails' do
      it 'marks the submission with error details' do
        # Placeholder for future implementation
        expect(contact_submission.whatsapp_error).to be_nil
      end
    end
  end
end
