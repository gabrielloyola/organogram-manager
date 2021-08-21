# frozen_string_literal: true

module Resolvers
  class ShowCompany < GraphQL::Schema::Resolver
    argument :id, ID, required: true

    type Types::CompanyType, null: false

    def resolve(id:)
      Company.find(id)
    rescue ActiveRecord::RecordNotFound => e
      GraphQL::ExecutionError.new(e)
    end
  end
end
