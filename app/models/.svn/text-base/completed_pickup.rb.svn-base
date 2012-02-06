require 'date'


class CompletedPickup < ActiveRecord::Base
  belongs_to :pickup

  def self.find_by_pickup_id(pickup_id)
    find(:first, :conditions => "pickup_id=#{pickup_id}")
  end

  def self.status(pickup_id)
    picked_up = find(:first, :conditions => "pickup_id=#{pickup_id}")
    picked_up.nil? ? '<b>Not Picked Up</b>' : 'Picked Up'
  end

end


