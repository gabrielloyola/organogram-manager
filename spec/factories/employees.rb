# frozen_string_literal: true

FactoryBot.define do
  factory :employee do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    company

    trait :with_manager do
      manager { create(:employee, company: company) }
    end

    trait :with_subordinates do
      before(:create) do |employee|
        create_pair(:employee, manager: employee, company: employee.company)
      end
    end
  end
end
