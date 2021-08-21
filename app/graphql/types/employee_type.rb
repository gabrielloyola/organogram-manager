# frozen_string_literal: true

module Types
  class EmployeeType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :email, String, null: false

    field :company, CompanyType, null: false
    field :manager, EmployeeType, null: true
    field :subordinates, [EmployeeType], null: true
  end
end
