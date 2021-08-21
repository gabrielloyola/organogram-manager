module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :show_company, resolver: Resolvers::Companies::Show
    field :all_companies, [CompanyType], null: false, description: 'List all Companies'

    def all_companies
      Company.all
    end
  end
end
