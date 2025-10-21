# frozen_string_literal: true

module RoleRedirectable
  extend ActiveSupport::Concern

  included do
    def after_sign_in_path_for(resource)
      case resource.role
      when 'administrator'
        admin_dashboard_path
      when 'tutor'
        tutors_dashboard_path
      when 'student'
        students_dashboard_path
      when 'parent'
        parents_dashboard_path
      else
        root_path
      end
    end
  end
end
