class AddKeyToSubdomain < ActiveRecord::Migration
  def self.up
    add_column :subdomains, :key, :string
  end

  def self.down
    remove_column :subdomains, :key
  end
end
