# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Employee, type: :model do
  subject(:employee) { create(:employee) }

  describe 'associations' do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to belong_to(:manager).class_name('Employee').optional }
    it { is_expected.to have_many(:subordinates).class_name('Employee') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }

    describe '#same_company' do
      context 'with manager from the same company' do
        before { employee.manager = create(:employee, company: employee.company) }

        it 'will be valid' do
          expect(employee.valid?).to be_truthy
        end
      end

      context 'with manager from another company' do
        let(:another_company) { build(:company) }

        before { employee.manager = create(:employee, company: another_company) }

        it 'will contain an error' do
          expect(employee.valid?).to be_falsey
          expect(employee.errors.messages[:manager]).to include('company must be the same of the employee\'s')
        end
      end
    end

    describe '#subordinate_loop' do
      context 'when manager isn\'t one of subordinates' do
        before { employee.manager = create(:employee, company: employee.company) }

        it 'will be valid' do
          expect(employee.valid?).to be_truthy
        end
      end

      context 'with manager from another company' do
        let(:subordinate) { create(:employee, company: employee.company, manager: employee) }

        before { employee.manager = subordinate }

        it 'will contain an error' do
          expect(employee.valid?).to be_falsey
          expect(employee.errors.messages[:manager]).to include('can\'t be one of the subordinates')
        end
      end
    end
  end
end
