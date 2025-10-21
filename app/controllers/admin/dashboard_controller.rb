# frozen_string_literal: true

module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_administrator!

    def index
      @user = current_user
    end

    private

    def ensure_administrator!
      redirect_to root_path, alert: 'Access denied.' unless current_user.administrator?
    end
  end
end
