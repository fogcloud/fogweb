class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.integer :user_id
      t.string  :name

      t.timestamps
    end

    add_index :blocks, :user_id
    add_index :blocks, :name, unique: true
  end
end
