# frozen_string_literal: true

module Mutations
  module Employees
    class DeleteEmployee < BaseMutation
      description 'Delete an Employee'

      argument :employee_id, ID, required: true

      type Types::EmployeeType

      def resolve(employee_id:)
        Employee.find(employee_id).destroy!
      rescue ActiveRecord::RecordNotFound => e
        GraphQL::ExecutionError.new(e)
      end
    end
  end
end
