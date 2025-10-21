# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Auth::Sessions', type: :request do
  let(:user) do
    User.create!(
      email: 'test@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      first_name: 'Test',
      last_name: 'User',
      role: :tutor
    )
  end

  describe 'GET /users/sign_in' do
    it 'returns http success' do
      get new_user_session_path
      expect(response).to have_http_status(:success)
    end

    it 'renders the login page' do
      get new_user_session_path
      expect(response.body).to include('Sign in')
    end
  end

  describe 'POST /users/sign_in' do
    context 'with valid credentials' do
      it 'signs in the user' do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: 'password123'
          }
        }
        expect(response).to have_http_status(:redirect)
      end

      it 'redirects to the appropriate dashboard' do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: 'password123'
          }
        }
        expect(response).to redirect_to(tutors_dashboard_path)
      end
    end

    context 'with invalid credentials' do
      it 'does not sign in the user' do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: 'wrongpassword'
          }
        }
        expect(response).to have_http_status(:unprocessable_content)
      end

      it 'renders the login page with error' do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: 'wrongpassword'
          }
        }
        expect(response.body).to include('Sign in')
      end
    end
  end

  describe 'DELETE /users/sign_out' do
    before do
      sign_in user
    end

    it 'signs out the user' do
      delete destroy_user_session_path
      expect(response).to have_http_status(:redirect)
    end

    it 'redirects to the root path' do
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path)
    end
  end
end
