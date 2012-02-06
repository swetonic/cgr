
class OrderDiscount < ActiveRecord::Base
  belongs_to :order
  
  def self.find_by_order_id(order_id)
    find(:first, :conditions => ['order_id=?', order_id])
  end
  
  def self.order_discount_total(order_id)
    discount_total = 0.0
    order = Order.find(order_id)
    
    unless order.nil?
      order.order_discounts.each do |order_discount|
        discount_total += order_discount.amount
      end
    end
    
    discount_total
  end
end














