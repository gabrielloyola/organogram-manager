# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_company,   mutation: Mutations::Companies::CreateCompany

    field :create_employee,  mutation: Mutations::Employees::CreateEmployee
    field :delete_employee,  mutation: Mutations::Employees::DeleteEmployee
    field :delegate_manager, mutation: Mutations::Employees::DelegateManager
  end
end
