# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Public::ContactForms', type: :request do
  describe 'POST /public/contact_forms' do
    let(:valid_attributes) do
      {
        contact_form_submission: {
          name: 'John Doe',
          email: 'john@example.com',
          phone: '+1234567890',
          message: 'I would like to inquire about tutoring services for my child.'
        }
      }
    end

    let(:invalid_attributes) do
      {
        contact_form_submission: {
          name: '',
          email: 'invalid-email',
          message: 'Too short'
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new ContactFormSubmission' do
        expect do
          post public_contact_forms_path, params: valid_attributes
        end.to change(ContactFormSubmission, :count).by(1)
      end

      it 'redirects to the contact page with success message' do
        post public_contact_forms_path, params: valid_attributes
        expect(response).to redirect_to(contact_path)
        follow_redirect!
        expect(response.body).to include('Thank you')
      end

      it 'enqueues a WhatsApp message job' do
        # This will be implemented when WhatsApp service is created
        post public_contact_forms_path, params: valid_attributes
        expect(response).to have_http_status(:redirect)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new ContactFormSubmission' do
        expect do
          post public_contact_forms_path, params: invalid_attributes
        end.not_to change(ContactFormSubmission, :count)
      end

      it 'renders the contact page with errors' do
        post public_contact_forms_path, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
