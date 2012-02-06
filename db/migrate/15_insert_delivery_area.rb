
class InsertDeliveryArea < ActiveRecord::Migration
  
  def self.up
    north_pickup_days = 'Monday, Thursday'

    north_title = 'North Seattle'

    
    [
        {:zip_code => 98105, :name => north_title, :delivery_day => north_pickup_days},
        
    ].each do |area|
      new_area = DeliveryArea.create(area)
      new_area.save!
    end

  end

  def self.down
    DeliveryArea.destroy_all
  end
end

