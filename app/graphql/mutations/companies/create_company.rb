module Mutations
  module Companies
    class CreateCompany < BaseMutation
      description 'Create a new Company'

      argument :name, String, required: true

      type Types::CompanyType

      def resolve(name:)
        Company.create!(name: name)
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end
