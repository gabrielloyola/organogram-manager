# frozen_string_literal: true

module Mutations
  module Employees
    class UnassignManager < BaseMutation
      description 'Unassign manager from Employee'

      argument :employee_id, ID, required: true

      type Types::EmployeeType

      def resolve(employee_id:)
        employee = Employee.find(employee_id)

        employee.update!(manager: nil)

        employee
      rescue ActiveRecord::RecordNotFound => e
        GraphQL::ExecutionError.new(e)
      end
    end
  end
end
