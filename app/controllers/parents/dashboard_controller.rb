# frozen_string_literal: true

module Parents
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_parent!

    def index
      @user = current_user
    end

    private

    def ensure_parent!
      redirect_to root_path, alert: 'Access denied.' unless current_user.parent?
    end
  end
end
