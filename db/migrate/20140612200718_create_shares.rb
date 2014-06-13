class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.string :root
      t.integer :blocks, null: false, default: 0

      t.timestamps
    end
  end
end
