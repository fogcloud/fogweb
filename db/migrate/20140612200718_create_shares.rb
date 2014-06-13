class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.string :root
      t.integer :block_size, null: false, default: 65536
      
      t.integer :block_count, null: false, default: 0
      t.integer :trans_bytes, null: false, default: 0

      t.timestamps
    end

    add_index :shares, :name
    add_index :shares, [:user_id, :name], unique: true
  end
end
