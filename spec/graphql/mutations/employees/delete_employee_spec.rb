# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Delete employee', type: :request do
  subject(:mutation_response) { json_response[:data][:deleteEmployee] }

  let!(:employee) { create(:employee) }
  let(:employee_id) { employee.id }

  let(:request) { post '/graphql', params: { query: query } }
  let(:query) do
    <<-GRAPHQL
      mutation {
        deleteEmployee(
          input: {
            employeeId: #{employee_id}
          }
        ) {
          id
          name
          email
          company {
              id
          }
        }
      }
    GRAPHQL
  end

  before do |example|
    request unless example.metadata[:skip_request]
  end

  it 'creates the employee', skip_request: true do
    expect { request }.to change(Employee, :count).from(1).to(0)
    expect { Employee.find(employee.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'returns the correct employee id and null manager id' do
    expect(mutation_response[:id].to_i).to eq(employee.id)
    expect(mutation_response[:manager]).to be_nil
  end

  context 'when employee id doesn\'t exists in database' do
    let(:employee_id) { 999 }

    it 'returns the RecordNotFound error message' do
      expect(json_response[:errors][0][:message]).to eq("Couldn't find Employee with 'id'=#{employee_id}")
    end
  end

  describe 'delegating subordinates', skip_request: true do
    context 'when the employee has subordinates and a manager' do
      let(:employee) { create(:employee, :with_manager, :with_subordinates) }

      it 'delegates the subordinates to his manager' do
        request
        expect(employee.subordinates.map(&:manager)).to all(employee.manager)
      end
    end

    context 'when the employee has subordinates but not a manager' do
      let(:employee) { create(:employee, :with_subordinates) }

      it 'subordinates will not have a delegated manager' do
        request
        expect(employee.subordinates.map(&:manager).uniq).to contain_exactly(nil)
      end
    end
  end
end
