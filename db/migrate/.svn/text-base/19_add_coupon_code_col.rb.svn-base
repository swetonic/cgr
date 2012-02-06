

class AddCouponCodeCol < ActiveRecord::Migration
  
  def self.up
    add_column :pickups, :coupon_code, :text, :limit => 128
  end

  def self.down
    remove_column :pickups
  end
  
end

