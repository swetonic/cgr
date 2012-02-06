

class CreateDeliveries < ActiveRecord::Migration
  
  def self.up
    create_table :deliveries do |t|
      t.integer :id
      t.integer :pickup_id
      t.datetime :delivery_date
      t.timestamps
    end
    
  end

  def self.down
    drop_table :deliveries
  end
  
end

