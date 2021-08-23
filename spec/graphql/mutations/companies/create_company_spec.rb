# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create company', type: :request do
  subject(:mutation_response) { json_response[:data][:createCompany] }

  let(:company_name) { Faker::Company.name }

  let(:request) { post '/graphql', params: { query: query } }
  let(:query) do
    <<-GRAPHQL
      mutation {
        createCompany(
          input: {
            name: "#{company_name}"
          }
        ) {
          id
          name
        }
      }
    GRAPHQL
  end

  it 'creates the Company with correct attributes' do
    expect { request }.to change(Company, :count).by(1)
    expect(mutation_response[:id].to_i).to eq(Company.last.id)
    expect(mutation_response[:name]).to eq(company_name)
  end
end
