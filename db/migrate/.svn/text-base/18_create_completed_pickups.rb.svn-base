class CreateCompletedPickups < ActiveRecord::Migration
  
  def self.up
    create_table :completed_pickups, :primary_key => 'id' do |t|
      t.column :id, :integer, :null => false
      t.column :pickup_id, :integer, :null => false
      t.column :pickup_date, :datetime, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :completed_pickups
  end
  
end
