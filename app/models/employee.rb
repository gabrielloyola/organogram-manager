# frozen_string_literal: true

class Employee < ApplicationRecord
  belongs_to :company
  belongs_to :manager, class_name: 'Employee', optional: true
  has_many :subordinates, class_name: 'Employee', foreign_key: 'manager_id'

  validates :name, :email, presence: true

  validate :same_company, :subordinate_loop

  def same_company
    return if manager_id.blank? || !manager_id_changed?
    return if manager.company.eql?(company)

    errors.add(:manager, 'Company must be the same of the employee\'s')
  end

  def subordinate_loop
    return if manager_id.blank? || !manager_id_changed?
    return if manager.manager != self

    errors.add(:manager, 'Can\'t be one of the subordinates')
  end
end
