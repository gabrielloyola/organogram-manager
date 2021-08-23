# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Delegate manager', type: :request do
  subject(:mutation_response) { json_response[:data][:delegateManager] }

  let(:employee) { create(:employee) }
  let(:manager) { create(:employee, company: employee.company) }
  let(:employee_id) { employee.id }

  let(:request) { post '/graphql', params: { query: query } }
  let(:query) do
    <<-GRAPHQL
      mutation {
        delegateManager(
          input: {
            employeeId: #{employee_id}
            managerId:  #{manager.id}
          }
        ) {
          id
          manager {
            id
          }
        }
      }
    GRAPHQL
  end

  before { request }

  it 'will delegate the manager to the employee' do
    expect(employee.reload.manager).to eql(manager)
  end

  it 'returns the correct employer and manager ids' do
    expect(mutation_response[:id].to_i).to eq(employee.id)
    expect(mutation_response[:manager][:id].to_i).to eq(manager.id)
  end

  context 'when employee id doesn\'t exists in database' do
    let(:employee_id) { 999 }

    it 'returns the RecordNotFound error message' do
      expect(json_response[:errors][0][:message]).to eq("Couldn't find Employee with 'id'=#{employee_id}")
    end
  end

  context 'when the chosen manager is employee\'s subordinate' do
    let(:manager) { create(:employee, manager: employee, company: employee.company) }

    it 'returns the RecordInvalid error message' do
      expect(json_response[:errors][0][:message]).to eq('Invalid input: Manager can\'t be one of the subordinates')
    end
  end

  context 'when the chosen manager is from another company' do
    let(:manager) { create(:employee) }

    it 'returns the RecordInvalid error message' do
      expect(json_response[:errors][0][:message]).to eq(
        'Invalid input: Manager company must be the same of the employee\'s'
      )
    end
  end
end
