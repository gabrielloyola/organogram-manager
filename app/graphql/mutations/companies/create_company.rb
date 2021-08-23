module Mutations
  module Companies
    class CreateCompany < BaseMutation
      description 'Create a new Company'

      argument :name, String, required: true

      type Types::CompanyType

      def resolve(name:)
        Company.create!(name: name)
      end
    end
  end
end
