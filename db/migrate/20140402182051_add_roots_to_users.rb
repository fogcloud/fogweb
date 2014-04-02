class AddRootsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :root, :string
    add_column :users, :log, :string
  end
end
