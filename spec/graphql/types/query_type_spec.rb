# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Query type - misc queries', type: :request do
  subject { described_class }

  describe 'all_companies' do
    let(:query_response) { json_response[:data][:allCompanies] }

    let!(:companies) { create_list(:company, 5) }

    let(:request) { post '/graphql', params: { query: query } }
    let(:query) do
      <<-GRAPHQL
        query {
          allCompanies {
            id
          }
        }
      GRAPHQL
    end

    before { request }

    it 'lists all the companies' do
      expect(query_response.pluck(:id).map(&:to_i)).to contain_exactly(*companies.pluck(:id))
    end
  end
end
