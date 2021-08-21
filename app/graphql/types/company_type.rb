# frozen_string_literal: true

module Types
  class CompanyType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false

    field :employees, [EmployeeType], null: true
  end
end
