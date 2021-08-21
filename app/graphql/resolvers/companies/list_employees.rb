# frozen_string_literal: true

module Resolvers
  module Companies
    class ListEmployees < GraphQL::Schema::Resolver
      description 'List all Employees of a Company'

      argument :company_id, ID, required: true

      type Types::EmployeeType.connection_type, null: false

      def resolve(company_id:)
        Company.find(company_id).employees
      rescue ActiveRecord::RecordNotFound => e
        GraphQL::ExecutionError.new(e)
      end
    end
  end
end
