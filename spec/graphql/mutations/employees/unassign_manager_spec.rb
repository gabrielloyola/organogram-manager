# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Delegate manager', type: :request do
  subject(:mutation_response) { json_response[:data][:unassignManager] }

  let(:employee) { create(:employee) }
  let(:employee_id) { employee.id }

  let(:request) { post '/graphql', params: { query: query } }
  let(:query) do
    <<-GRAPHQL
      mutation {
        unassignManager(
          input: {
            employeeId: #{employee_id}
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

  it 'unassigns the manager of the employee' do
    expect(employee.reload.manager).to be_nil
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
end
