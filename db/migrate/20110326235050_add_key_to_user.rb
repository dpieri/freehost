class AddKeyToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :key, :string
  end

  def self.down
    remove_column :users, :key
  end
end
