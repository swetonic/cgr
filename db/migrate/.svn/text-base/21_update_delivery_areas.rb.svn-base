
class UpdateDeliveryAreas < ActiveRecord::Migration
  
  def self.up
    north_pickup_days = 'Monday, Thursday'
    south_pickup_days = 'Monday, Thursday'
    dt_pickup_days = 'Tuesday, Friday'
    new_pickup_days = 'Tuesday, Friday'


    north_title = 'North Seattle'
    south_title = 'Magnolia, Belltown'
    dt_title = 'Downtown, Queen Anne'
    new_title = 'Eastlake, Madison Park'
    
    [
        #monday and thursday    
        {:zip_code => 98133, :name => north_title, :delivery_day => north_pickup_days},
        {:zip_code => 98177, :name => north_title, :delivery_day => north_pickup_days},
        {:zip_code => 98117, :name => north_title, :delivery_day => north_pickup_days},
        {:zip_code => 98107, :name => north_title, :delivery_day => north_pickup_days},

        #tuesday and friday
        {:zip_code => 98103, :name => dt_title, :delivery_day => dt_pickup_days},
        {:zip_code => 98115, :name => dt_title, :delivery_day => dt_pickup_days},
        {:zip_code => 98105, :name => dt_title, :delivery_day => dt_pickup_days},
        {:zip_code => 98125, :name => dt_title, :delivery_day => dt_pickup_days},
        {:zip_code => 98155, :name => dt_title, :delivery_day => dt_pickup_days},


        #monday and thursday
        {:zip_code => 98119, :name => south_title, :delivery_day => south_pickup_days},
        {:zip_code => 98109, :name => south_title, :delivery_day => south_pickup_days},
        {:zip_code => 98121, :name => south_title, :delivery_day => south_pickup_days},
        {:zip_code => 98101, :name => south_title, :delivery_day => south_pickup_days},
        {:zip_code => 98174, :name => south_title, :delivery_day => south_pickup_days},
        {:zip_code => 98104, :name => south_title, :delivery_day => south_pickup_days},
        {:zip_code => 98154, :name => south_title, :delivery_day => south_pickup_days},

        {:zip_code => 98102, :name => new_title, :delivery_day => new_pickup_days},
        {:zip_code => 98112, :name => new_title, :delivery_day => new_pickup_days},
        {:zip_code => 98122, :name => new_title, :delivery_day => new_pickup_days},


    ].each do |area|
      new_area = DeliveryArea.create(area)
      new_area.save!
    end

  end

  def self.down
    DeliveryArea.destroy_all
  end
end

