# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'List pairs', type: :request do
  subject(:query_response) { json_response[:data][:listPairs][:nodes] }

  let(:manager) { create(:employee, :with_subordinates) }
  let(:employee_id) { manager.subordinates.first.id }

  let(:request) { post '/graphql', params: { query: query } }
  let(:query) do
    <<-GRAPHQL
      query {
        listPairs(
          employeeId: #{employee_id}
        ) {
          nodes {
            id
          }
        }
      }
    GRAPHQL
  end

  before do
    create_pair(:employee, company: manager.company)

    request
  end

  it 'retrieves only the pair employees' do
    expect(query_response.pluck(:id).map(&:to_i)).to contain_exactly(
      *manager.subordinates.pluck(:id).reject { |id| id == employee_id }
    )
  end

  context 'when employee id doesn\'t exists in database' do
    let(:employee_id) { 999 }

    it 'returns the RecordNotFound error message' do
      expect(json_response[:errors][0][:message]).to eq("Couldn't find Employee with 'id'=#{employee_id}")
    end
  end

  context 'when employee doesn\'t have a manager' do
    let(:employee_id) { create(:employee).id }

    it 'returns the error message' do
      expect(json_response[:errors][0][:message]).to eq('Employee doesn\'t have a manager')
    end
  end
end
