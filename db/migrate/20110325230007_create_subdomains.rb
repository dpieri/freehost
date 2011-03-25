class CreateSubdomains < ActiveRecord::Migration
  def self.up
    create_table :subdomains do |t|
      t.string :name
      t.references :user
      t.boolean :is_confirmed

      t.timestamps
    end
  end

  def self.down
    drop_table :subdomains
  end
end
