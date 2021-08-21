# frozen_string_literal: true

FactoryBot.define do
  factory :employee do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    company

    trait :with_manager do
      manager { create(:employee, company: company) }
    end
  end
end
