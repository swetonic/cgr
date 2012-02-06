class CreateDeliveryAreas < ActiveRecord::Migration
  
  def self.up
    create_table :delivery_areas do |t|
      t.integer :id
      t.string :name, :limit => 64
      t.string :delivery_day, :limit => 64
      t.integer :zip_code
      t.timestamps
    end
  end

  def self.down
    drop_table :delivery_areas    
  end
end

