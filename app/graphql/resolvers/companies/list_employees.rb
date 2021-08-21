# frozen_string_literal: true

module Resolvers
  module Companies
    class ListEmployees < GraphQL::Schema::Resolver
      description 'List all Employees of a Company'

      argument :id, ID, required: true

      type Types::EmployeeType.connection_type, null: false

      def resolve(id:)
        Company.find(id).employees
      rescue ActiveRecord::RecordNotFound => e
        GraphQL::ExecutionError.new(e)
      end
    end
  end
end
