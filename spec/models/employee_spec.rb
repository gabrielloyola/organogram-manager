# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Employee, type: :model do
  subject(:employee) { create(:employee) }

  it { is_expected.to belong_to(:company) }
  it { is_expected.to belong_to(:manager).class_name('Employee').optional }
  it { is_expected.to have_many(:subordinates).class_name('Employee') }

  describe 'validations' do
    describe '#same_company?' do
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
          expect(employee.errors.messages[:manager]).to include('Company must be the same of the employee\'s')
        end
      end
    end
  end
end
