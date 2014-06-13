class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :email, null: false
      t.string  :auth_key, null: false
      t.boolean :admin, null: false, default: false
      t.integer :plan_id
      t.date    :expires, null: false, default: "1995-01-01"

      t.timestamps
    end

    add_index :users, :auth_key, unique: true
  end
end
