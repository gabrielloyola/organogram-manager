# frozen_string_literal: true

class AddManagerToEmployee < ActiveRecord::Migration[6.1]
  def change
    add_reference :employees, :manager, index: true
  end
end
