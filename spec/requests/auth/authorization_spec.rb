# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Auth::Authorization', type: :request do
  describe 'accessing protected pages without authentication' do
    it 'redirects to login page when accessing tutor dashboard' do
      get '/tutors/dashboard'
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to login page when accessing student dashboard' do
      get '/students/dashboard'
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to login page when accessing parent dashboard' do
      get '/parents/dashboard'
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to login page when accessing admin dashboard' do
      get '/admin/dashboard'
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'role-based access control' do
    let(:tutor) do
      User.create!(
        email: 'tutor@example.com',
        password: 'password123',
        password_confirmation: 'password123',
        first_name: 'Tutor',
        last_name: 'User',
        role: :tutor
      )
    end

    let(:student) do
      User.create!(
        email: 'student@example.com',
        password: 'password123',
        password_confirmation: 'password123',
        first_name: 'Student',
        last_name: 'User',
        role: :student
      )
    end

    it 'allows tutor to access tutor dashboard' do
      sign_in tutor
      get '/tutors/dashboard'
      expect(response).to have_http_status(:success)
    end

    it 'allows student to access student dashboard' do
      sign_in student
      get '/students/dashboard'
      expect(response).to have_http_status(:success)
    end
  end
end
