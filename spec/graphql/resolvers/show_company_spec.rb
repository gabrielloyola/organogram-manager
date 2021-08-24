# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Delete employee', type: :request do
  subject(:query_response) { json_response[:data][:showCompany] }

  let(:company) { create(:company) }
  let(:company_id) { company.id }

  let(:request) { post '/graphql', params: { query: query } }
  let(:query) do
    <<-GRAPHQL
      query {
        showCompany(
          companyId: #{company_id}
        ) {
          id
          name
        }
      }
    GRAPHQL
  end

  before { request }

  it 'retrieves the company attributes' do
    expect(query_response[:id].to_i).to eq(company.id)
    expect(query_response[:name]).to eq(company.name)
  end

  context 'when employee id doesn\'t exists in database' do
    let(:company_id) { 999 }

    it 'returns the RecordNotFound error message' do
      expect(json_response[:errors][0][:message]).to eq("Couldn't find Company with 'id'=#{company_id}")
    end
  end
end
