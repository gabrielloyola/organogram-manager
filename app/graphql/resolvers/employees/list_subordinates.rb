# frozen_string_literal: true

module Resolvers
  module Employees
    class ListSubordinates < GraphQL::Schema::Resolver
      description 'List all Employees managed by an Employee'

      argument :id, ID, required: true

      type Types::EmployeeType.connection_type, null: false

      def resolve(id:)
        employee = Employee.find(id)

        employee.subordinates
      rescue ActiveRecord::RecordNotFound => e
        GraphQL::ExecutionError.new(e)
      end
    end
  end
end
