# frozen_string_literal: true

module Public
  class PagesController < ApplicationController
    skip_before_action :authenticate_user!, raise: false

    def home
      # Homepage - marketing content
    end

    def about
      # About page - company information
    end

    def services
      # Services page - tutoring offerings
    end

    def contact
      # Contact page - contact form
    end

    def how_it_works
      # How It Works page - process explanation
    end

    def tutors
      # Tutors page - team profiles
    end

    def subjects
      # Subjects page - curriculum and subjects offered
    end

    def testimonials
      # Testimonials page - parent and student reviews
    end

    def book_assessment
      # Book Assessment page - free assessment booking
    end

    def blog
      # Blog page - articles and resources
    end

    def privacy_policy
      # Privacy Policy page
    end

    def terms_of_service
      # Terms of Service page
    end

    def cookie_policy
      # Cookie Policy page
    end
  end
end
