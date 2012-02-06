
class InsertDeliveryAreas < ActiveRecord::Migration
  
  def self.up
    north_pickup_days = 'Monday, Thursday'
    south_pickup_days = 'Wednesday, Saturday'
    dt_pickup_days = 'Tuesday, Friday'


    north_title = 'North Seattle'
    south_title = 'South King County, Kent'
    dt_title = 'Downtown, West Seattle, Queen Anne'
    
    [
        {:zip_code => 98107, :name => north_title, :delivery_day => north_pickup_days},
        {:zip_code => 98117, :name => north_title, :delivery_day => north_pickup_days},
        {:zip_code => 98115, :name => north_title, :delivery_day => north_pickup_days},
        {:zip_code => 98105, :name => north_title, :delivery_day => north_pickup_days},
        {:zip_code => 98103, :name => north_title, :delivery_day => north_pickup_days},

        {:zip_code => 98198, :name => south_title, :delivery_day => south_pickup_days},
        {:zip_code => 98148, :name => south_title, :delivery_day => south_pickup_days},
        {:zip_code => 98166, :name => south_title, :delivery_day => south_pickup_days},
        {:zip_code => 98031, :name => south_title, :delivery_day => south_pickup_days},
        {:zip_code => 98032, :name => south_title, :delivery_day => south_pickup_days},

        {:zip_code => 98121, :name => dt_title, :delivery_day => dt_pickup_days},
        {:zip_code => 98109, :name => dt_title, :delivery_day => dt_pickup_days},
        {:zip_code => 98101, :name => dt_title, :delivery_day => dt_pickup_days},
        {:zip_code => 98164, :name => dt_title, :delivery_day => dt_pickup_days},
        {:zip_code => 98154, :name => dt_title, :delivery_day => dt_pickup_days},
        {:zip_code => 98174, :name => dt_title, :delivery_day => dt_pickup_days},
        {:zip_code => 98104, :name => dt_title, :delivery_day => dt_pickup_days},
        {:zip_code => 98116, :name => dt_title, :delivery_day => dt_pickup_days},
        {:zip_code => 98106, :name => dt_title, :delivery_day => dt_pickup_days},
        {:zip_code => 98126, :name => dt_title, :delivery_day => dt_pickup_days},
        {:zip_code => 98134, :name => dt_title, :delivery_day => dt_pickup_days},
        {:zip_code => 98136, :name => dt_title, :delivery_day => dt_pickup_days},
        {:zip_code => 98119, :name => dt_title, :delivery_day => dt_pickup_days},
        {:zip_code => 98102, :name => dt_title, :delivery_day => dt_pickup_days},
        {:zip_code => 98112, :name => dt_title, :delivery_day => dt_pickup_days},
        
    ].each do |area|
      new_area = DeliveryArea.create(area)
      new_area.save!
    end

  end

  def self.down
    DeliveryArea.destroy_all
  end
end

