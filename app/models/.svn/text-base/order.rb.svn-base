
class Order < ActiveRecord::Base
  has_many :order_items
  has_many :order_discounts
  has_many :payments
  belongs_to :user
  belongs_to :admin
  
  TAX_RATE = 0.095
  
  def self.get_item_amounts(order_id, paid=true)
    alteration_ids = CleaningCategoryItem.alteration_ids
    
    amounts = {:alterations => 0.0, :dry_cleaning => 0.0}
    begin
      order = find(order_id)
      unless not order.paid == paid
        order.order_items.each do |item|
          amount = (item.quantity * item.unit_price * item.discount)
          if alteration_ids.key?(item.cleaning_category_item_id)
            amounts[:alterations] += amount
          else
            amounts[:dry_cleaning] += amount
          end
        end
      end
    rescue Exception => e
    end
    amounts
  end
    
  def self.delete_order_items(order_id)
    order = find(order_id)
    order.order_items.each do |item|
      item.destroy
    end
  end
  
  def self.order_count_by_month(month_num, year_num)
    orders = find(:all, 
      :conditions => sprintf("created_on like '%d-%02d%%'", year_num, month_num),
      :select => 'count(*)')
    count = orders[0].attributes['count(*)']
    count.to_i
  end

  def self.paid_order_items_by_month(month_num, year_num)
    counts = {}
    orders = find(:all, 
      :conditions => sprintf("created_on like '%d-%02d%%' and paid=1", 
          year_num, month_num))
    orders.each do |order|
      order.order_items.each do |item|
        if not counts.key?(item.cleaning_category_item_id)
          counts[item.cleaning_category_item_id] = {:count => 0, :amount => 0.0}
        end
        counts[item.cleaning_category_item_id][:count] += item.quantity.to_i
        counts[item.cleaning_category_item_id][:amount] += 
            (item.quantity*item.unit_price * item.discount)
      end
    end  
    return_counts = []
    counts.each do |cat_item_id, details|
      category_item = CleaningCategoryItem.find(cat_item_id)
      return_counts << {:category => category_item.name, 
          :count => details[:count], :amount => details[:amount]}
    end
    
    return_counts.sort { |a,b| b[:amount] <=> a[:amount]}
  end
  
end














