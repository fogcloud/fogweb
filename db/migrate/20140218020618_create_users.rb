class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.integer :plan_id
      t.decimal :credit_usd, precision: 10, scale: 2
      t.boolean :autobill, null: false, default: false

      t.timestamps
    end
  end
end
