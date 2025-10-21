# frozen_string_literal: true

module Public
  class ContactFormsController < ApplicationController
    skip_before_action :authenticate_user!, raise: false

    def create
      @submission = ContactFormSubmission.new(contact_form_params)

      if @submission.save
        # Send WhatsApp message via service
        Whatsapp::SendMessageService.new(@submission).call
        
        redirect_to contact_path, notice: 'Thank you for your message! We will contact you soon via WhatsApp.'
      else
        @contact_form_submission = @submission
        render 'public/pages/contact', status: :unprocessable_content
      end
    end

    private

    def contact_form_params
      params.require(:contact_form_submission).permit(:name, :email, :phone, :message)
    rescue ActionController::ParameterMissing
      params.permit(:name, :email, :phone, :message)
    end
  end
end
