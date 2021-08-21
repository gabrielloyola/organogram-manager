# frozen_string_literal: true

module Mutations
  module Employees
    class DelegateManager < BaseMutation
      description 'Delegate a manager to an Employee'

      argument :employee_id, ID, required: true
      argument :manager_id,  ID, required: true

      type Types::EmployeeType

      def resolve(employee_id:, manager_id:)
        manager = Employee.find(manager_id)
        employee = Employee.find(employee_id)

        employee.update!(manager: manager)

        employee
      rescue ActiveRecord::RecordNotFound => e
        GraphQL::ExecutionError.new(e)
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end
