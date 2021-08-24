# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'List subordinates', type: :request do
  subject(:query_response) { json_response[:data][:listSubordinates][:nodes] }

  let(:employee) { create(:employee, :with_subordinates) }
  let(:employee_id) { employee.id }

  let(:second_level) { false }

  let!(:second_level_employees) do
    [
      create(:employee, company: employee.company, manager: employee.subordinates.first),
      create(:employee, company: employee.company, manager: employee.subordinates.second)
    ]
  end

  let(:request) { post '/graphql', params: { query: query } }
  let(:query) do
    <<-GRAPHQL
      query {
        listSubordinates(
          employeeId: #{employee_id}
          secondLevel: #{second_level}
        ) {
          nodes {
            id
            name
          }
        }
      }
    GRAPHQL
  end

  before do
    create_pair(:employee, company: employee.company)

    request
  end

  it 'retrieves only the subordinate employees' do
    expect(query_response.pluck(:id).map(&:to_i)).to contain_exactly(*employee.subordinates.pluck(:id))
  end

  context 'when listing second level of subordinates' do
    let(:second_level) { true }

    it 'retrieves only the second level subordinate employees' do
      expect(query_response.pluck(:id).map(&:to_i)).to contain_exactly(*second_level_employees.pluck(:id))
    end
  end

  context 'when employee id doesn\'t exists in database' do
    let(:employee_id) { 999 }

    it 'returns the RecordNotFound error message' do
      expect(json_response[:errors][0][:message]).to eq("Couldn't find Employee with 'id'=#{employee_id}")
    end
  end
end
