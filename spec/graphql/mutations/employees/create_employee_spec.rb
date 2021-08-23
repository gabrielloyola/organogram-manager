# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create employee', type: :request do
  subject(:mutation_response) { json_response[:data][:createEmployee] }

  let(:company) { create(:company) }
  let(:company_id) { company.id }

  let(:name) { Faker::Name.name }
  let(:email) { Faker::Internet.email }

  let(:manager_id) { 'null' }

  let(:request) { post '/graphql', params: { query: query } }
  let(:query) do
    <<-GRAPHQL
      mutation {
        createEmployee(
          input: {
            name:      "#{name}"
            email:     "#{email}"
            companyId: #{company_id}
            managerId: #{manager_id}
          }
        ) {
          id
          name
          email
          company {
            id
          }
          manager {
            id
          }
        }
      }
    GRAPHQL
  end

  before do |example|
    request unless example.metadata[:skip_request]
  end

  it 'creates the employee', skip_request: true do
    expect { request }.to change(Employee, :count).by(1)
    expect(mutation_response[:id].to_i).to eq(last_employee.id)
  end

  it 'creates the employee with correct fields' do
    expect(last_employee.name).to eq(name)
    expect(last_employee.email).to eq(email)
  end

  it 'returns the fields according with the created Employee' do
    expect(mutation_response[:name]).to eq(last_employee.name)
    expect(mutation_response[:email]).to eq(last_employee.email)
  end

  context 'when employee id doesn\'t exists in database' do
    let(:company_id) { 999 }

    it 'returns the RecordNotFound error message' do
      expect(json_response[:errors][0][:message]).to eq('Invalid input: Company must exist')
    end
  end

  context 'when pass manager_id argument' do
    let(:manager) { create(:employee, company: company) }
    let(:manager_id) { manager.id }

    it 'delegates the manager to the employee' do
      expect(last_employee.manager).to eq(manager)
      expect(mutation_response[:manager][:id].to_i).to eq(manager_id)
    end

    context 'when manager isn\'t from the same company' do
      let(:manager) { create(:employee) }

      it 'returns the RecordInvalid error message' do
        expect(json_response[:errors][0][:message]).to eq(
          'Invalid input: Manager company must be the same of the employee\'s'
        )
      end
    end
  end

  # Avoid to hit the db too many times
  def last_employee
    @last_employee ||= Employee.last
  end
end
