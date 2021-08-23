# frozen_string_literal: true

class Employee < ApplicationRecord
  belongs_to :company
  belongs_to :manager, class_name: 'Employee', optional: true
  has_many :subordinates, class_name: 'Employee', foreign_key: 'manager_id'

  validates :name, :email, presence: true

  validate :same_company, :subordinate_loop, :manage_himself,
           unless: -> { manager_id.nil? || !manager_id_changed? }

  before_destroy :delegate_subordinates, if: -> { subordinates.any? && manager.present? }

  def same_company
    return if manager.company.eql?(company)

    errors.add(:manager, 'company must be the same of the employee\'s')
  end

  def subordinate_loop
    current_manager = manager

    while current_manager.present?
      return errors.add(:manager, 'can\'t be one of the subordinates') if current_manager.eql?(self)

      current_manager = current_manager.manager
    end
  end

  def manage_himself
    return if manager != self

    errors.add(:manager, 'can\'t be the employee')
  end

  def delegate_subordinates
    subordinates.each { |subordinate| subordinate.update!(manager: manager) }
  end
end
