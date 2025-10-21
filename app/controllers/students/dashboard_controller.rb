# frozen_string_literal: true

module Students
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_student!

    def index
      @user = current_user
    end

    private

    def ensure_student!
      redirect_to root_path, alert: 'Access denied.' unless current_user.student?
    end
  end
end
