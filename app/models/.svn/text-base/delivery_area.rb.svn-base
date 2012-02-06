
class DeliveryArea < ActiveRecord::Base

  def self.zipcode_exists?(zip)
    exists?(:zip_code => zip)
  end

  def self.delivery_days(zip)
    if zipcode_exists?(zip)
      find(:first, :conditions => "zip_code=#{zip}", :select => 'delivery_day').delivery_day
    else
      ''
    end
  end

end
