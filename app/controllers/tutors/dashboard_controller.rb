# frozen_string_literal: true

module Tutors
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_tutor!

    def index
      @user = current_user
    end

    private

    def ensure_tutor!
      redirect_to root_path, alert: 'Access denied.' unless current_user.tutor?
    end
  end
end
