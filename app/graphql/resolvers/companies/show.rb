# frozen_string_literal: true

module Resolvers
  module Companies
    class Show < GraphQL::Schema::Resolver
      argument :id, ID, required: true

      type Types::CompanyType, null: false

      def resolve(id:)
        Company.find(id)
      rescue ActiveRecord::RecordNotFound => e
        GraphQL::ExecutionError.new(e)
      end
    end
  end
end
