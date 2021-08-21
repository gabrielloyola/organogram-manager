# frozen_string_literal: true

module Mutations
  module Employees
    class CreateEmployee < BaseMutation
      description 'Create a new Employee'

      argument :name,       String, required: true
      argument :email,      String, required: true
      argument :company_id, ID,     required: true
      argument :manager_id, ID,     required: false

      type Types::EmployeeType

      def resolve(name:, email:, company_id:, manager_id: nil)
        employee = Employee.new(name: name, email: email, company_id: company_id)

        employee.manager_id = manager_id if manager_id.present?
        employee.save!

        employee
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end
