# frozen_string_literal: true

class Company < ApplicationRecord
  has_many :employees

  validates :name, presence: true
end
