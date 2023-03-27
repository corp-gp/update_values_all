# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table(:users, force: true) do |t|
    t.string :name
    t.string :state
    t.jsonb :address
    t.timestamps
  end
end
