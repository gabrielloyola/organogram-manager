# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'List employees', type: :request do
  subject(:query_response) { json_response[:data][:companyEmployees][:nodes] }

  let(:company) { create(:company) }
  let(:company_id) { company.id }

  let!(:company_employees) { create_pair(:employee, company: company) }
  let!(:other_employees) { create_pair(:employee) }

  let(:request) { post '/graphql', params: { query: query } }
  let(:query) do
    <<-GRAPHQL
      query {
        companyEmployees(
          companyId: #{company_id}
        ) {
          nodes {
            id
            name
          }
        }
      }
    GRAPHQL
  end

  before { request }

  it 'retrieves only the company employees' do
    expect(query_response.pluck(:id).map(&:to_i)).to contain_exactly(*company_employees.pluck(:id))
  end

  context 'when employee id doesn\'t exists in database' do
    let(:company_id) { 999 }

    it 'returns the RecordNotFound error message' do
      expect(json_response[:errors][0][:message]).to eq("Couldn't find Company with 'id'=#{company_id}")
    end
  end
end
