class CreateSettingsTable < ActiveRecord::Migration
  
  def self.up
    create_table :settings do |t|
      t.column :id, :integer, :null => false
      t.column :name, :string, :null => true
      t.column :value, :string, :null => true
    end
    add_index(:settings, :name, :unique => true, :name => 'unique_name')

  end

  def self.down
    drop_table :settings
  end
  
end
