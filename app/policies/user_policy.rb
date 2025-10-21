# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    user.administrator?
  end

  def show?
    user.administrator? || record == user
  end

  def create?
    user.administrator?
  end

  def update?
    user.administrator?
  end

  def destroy?
    user.administrator?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.administrator?
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end
end
