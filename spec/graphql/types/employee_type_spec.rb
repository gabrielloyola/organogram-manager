# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::EmployeeType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:name).of_type('String!') }
  it { is_expected.to have_field(:email).of_type('String!') }

  it { is_expected.to have_field(:company).of_type('Company!') }
  it { is_expected.to have_field(:manager).of_type('Employee') }
  it { is_expected.to have_field(:subordinates).of_type('[Employee!]') }
end
