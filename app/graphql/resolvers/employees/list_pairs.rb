# frozen_string_literal: true

module Resolvers
  module Employees
    class ListPairs < GraphQL::Schema::Resolver
      description 'List all pairs of an Employee'

      argument :id, ID, required: true

      type Types::EmployeeType.connection_type, null: false

      def resolve(id:)
        employee = Employee.find(id)

        raise GraphQL::ExecutionError, 'Employee doesn\'t have a manager' if employee.manager.blank?

        employee.manager.subordinates.where.not(id: employee.id)
      rescue ActiveRecord::RecordNotFound => e
        GraphQL::ExecutionError.new(e)
      end
    end
  end
end
