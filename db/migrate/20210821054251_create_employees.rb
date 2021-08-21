# frozen_string_literal: true

class CreateEmployees < ActiveRecord::Migration[6.1]
  def change
    create_table :employees do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
