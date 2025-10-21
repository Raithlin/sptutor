# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  
  # Public marketing pages
  root 'public/pages#home'
  get 'about', to: 'public/pages#about'
  get 'how-it-works', to: 'public/pages#how_it_works'
  get 'tutors', to: 'public/pages#tutors'
  get 'subjects', to: 'public/pages#subjects'
  get 'testimonials', to: 'public/pages#testimonials'
  get 'book-assessment', to: 'public/pages#book_assessment'
  get 'blog', to: 'public/pages#blog'
  
  # Policy pages
  get 'privacy-policy', to: 'public/pages#privacy_policy'
  get 'terms-of-service', to: 'public/pages#terms_of_service'
  get 'cookie-policy', to: 'public/pages#cookie_policy'
  
  # Legacy routes (keeping for compatibility)
  get 'services', to: 'public/pages#services'
  get 'contact', to: 'public/pages#contact'
  
  # Contact form submission
  namespace :public do
    resources :contact_forms, only: [:create]
  end

  # Role-based dashboards
  namespace :tutors do
    get 'dashboard', to: 'dashboard#index'
  end

  namespace :students do
    get 'dashboard', to: 'dashboard#index'
  end

  namespace :parents do
    get 'dashboard', to: 'dashboard#index'
  end

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
  end

  # Health check
  get 'up' => 'rails/health#show', as: :rails_health_check
end
