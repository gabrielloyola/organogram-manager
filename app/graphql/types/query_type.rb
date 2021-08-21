# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :all_companies, [CompanyType], null: false, description: 'List all Companies'

    field :show_company,      resolver: Resolvers::Companies::ShowCompany
    field :company_employees, resolver: Resolvers::Companies::ListEmployees

    field :list_pairs,        resolver: Resolvers::Employees::ListPairs
    field :list_subordinates, resolver: Resolvers::Employees::ListSubordinates

    def all_companies
      Company.all
    end
  end
end
