# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  subject { described_class.new(current_user, user) }

  let(:user) { User.new(role: :student) }

  context 'when user is an administrator' do
    let(:current_user) { User.new(role: :administrator) }

    it 'permits all actions' do
      expect(subject.index?).to be true
      expect(subject.show?).to be true
      expect(subject.create?).to be true
      expect(subject.update?).to be true
      expect(subject.destroy?).to be true
    end
  end

  context 'when user is a tutor' do
    let(:current_user) { User.new(role: :tutor) }

    it 'forbids management actions' do
      expect(subject.index?).to be false
      expect(subject.create?).to be false
      expect(subject.update?).to be false
      expect(subject.destroy?).to be false
    end
  end

  context 'when user is a student' do
    let(:current_user) { User.new(role: :student) }

    it 'forbids management actions' do
      expect(subject.index?).to be false
      expect(subject.create?).to be false
      expect(subject.update?).to be false
      expect(subject.destroy?).to be false
    end
  end

  context 'when user is a parent' do
    let(:current_user) { User.new(role: :parent) }

    it 'forbids management actions' do
      expect(subject.index?).to be false
      expect(subject.create?).to be false
      expect(subject.update?).to be false
      expect(subject.destroy?).to be false
    end
  end

  context 'when viewing own profile' do
    let(:current_user) { user }

    it 'permits show action' do
      expect(subject.show?).to be true
    end
  end
end
