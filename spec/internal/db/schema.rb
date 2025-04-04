# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table(:users, force: true) do |t|
    t.string :name
    t.string :state
    t.jsonb :address
    t.timestamps
  end

  create_table(:product_users, id: false, force: true) do |t|
    t.bigint :product_id
    t.bigint :user_id
    t.string :state
    t.timestamps
  end
end
