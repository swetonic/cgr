class CreateDeletedOrders < ActiveRecord::Migration
  def self.up
    create_table :deleted_orders do |t|
      t.text :html, :limit => 1024, :null => false
      t.text :reason, :limit => 64
      t.timestamps
      t.integer :admin_id
    end

  end

  def self.down
    drop_table :deleted_orders
  end
end
