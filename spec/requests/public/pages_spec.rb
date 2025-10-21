# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Public::Pages', type: :request do
  include Rails.application.routes.url_helpers
  describe 'GET /' do
    it 'returns http success' do
      get root_path
      expect(response).to have_http_status(:success)
    end

    it 'renders the home page' do
      get root_path
      expect(response.body).to include('Smarty Pants Tutoring')
    end
  end

  describe 'GET /about' do
    it 'returns http success' do
      get about_path
      expect(response).to have_http_status(:success)
    end

    it 'renders the about page' do
      get about_path
      expect(response.body).to include('About')
    end
  end

  describe 'GET /services' do
    it 'returns http success' do
      get services_path
      expect(response).to have_http_status(:success)
    end

    it 'renders the services page' do
      get services_path
      expect(response.body).to include('Services')
    end
  end

  describe 'GET /contact' do
    it 'returns http success' do
      get contact_path
      expect(response).to have_http_status(:success)
    end

    it 'renders the contact page with form' do
      get contact_path
      expect(response.body).to include('Contact')
    end
  end
end
