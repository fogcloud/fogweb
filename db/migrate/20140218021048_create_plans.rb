class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :megs
      t.decimal :usd_per_month, precision: 10, scale: 2

      t.timestamps
    end
  end
end
