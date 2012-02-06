class AddUuid < ActiveRecord::Migration
  
  def self.up
    add_column :users, :uuid, :string, {:limit => 64, :default => ''}
    add_column :users, :verified, :boolean, {:default => false}
  end

  def self.down
    remove_column :users, :uuid
    remove_column :users, :verified
  end
  
end
