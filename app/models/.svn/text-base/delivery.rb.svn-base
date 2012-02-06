
class Delivery < ActiveRecord::Base
  belongs_to :pickup

  def self.find_by_pickup_id(pickup_id)
    find(:first, :conditions => "pickup_id=#{pickup_id}")
  end

  def self.status(pickup_id)
    delivered = find_by_pickup_id(pickup_id)
    delivered.nil? ? "<b>Not Delivered</b>" : "Delivered"
  end

end
