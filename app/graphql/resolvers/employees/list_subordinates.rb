# frozen_string_literal: true

module Resolvers
  module Employees
    class ListSubordinates < GraphQL::Schema::Resolver
      description 'List all Employees managed by an Employee'

      argument :employee_id, ID, required: true
      argument :second_level, Boolean, required: false

      type Types::EmployeeType.connection_type, null: false

      def resolve(employee_id:, second_level: false)
        employee = Employee.find(employee_id)

        return employee.subordinates unless second_level

        # Retrieve all subordinates of employee subordinates in one single list
        employee.subordinates.flat_map(&:subordinates)
      rescue ActiveRecord::RecordNotFound => e
        GraphQL::ExecutionError.new(e)
      end
    end
  end
end
