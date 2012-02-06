
class Payment < ActiveRecord::Base
  belongs_to :order

  MONTH_NAMES = ['January', 'February', 'March', 'April', 'May', 'June', 'July',
    'August', 'September', 'October', 'November', 'December' ]
  
  def self.find_payments_by_date(date)
    find(:all, :conditions => sprintf("created_on like '%s%%'", date))
  end

  def self.order_paid_on(order_id)
    payment = find(:first, :conditions => "order_id=#{order_id}")
    unless payment.nil?
      return payment.payment_date.strftime("%m/%d/%y")
    end
    ''
  end

  def self.payments_made(order_id)
    find(:all, :conditions => ["order_id=?", order_id])
  end
  
  def self.payments_made_sum(order_id)
    sum = 0.0
    payments = find(:all, :conditions => ["order_id=?", order_id])
    payments.each { |pmt| sum += pmt.amount }
    sum
  end

  def self.get_payment_months
    months = {}
    payments = find(:all, :group => 'created_on')
    payments.each do |pmt|
      created = pmt.created_on.month
      months[created] = [MONTH_NAMES[created - 1], pmt.created_on.year]
    end
    months
  end
  
  def self.get_payments_by_month(month_num, year)
    conditions = sprintf("created_on like '%d-%02d%%'", 
                    year, month_num)
    find(:all, :conditions => conditions)
  end

  def self.get_alterations_by_month(month_num, year)
    alterations_total = 0.0
    payments = get_payments_by_month(month_num, year)
    payments.each do |pmt|
     amounts = Order.get_item_amounts(pmt.order_id)
     alterations_total += amounts[:alterations]
    end
    alterations_total
  end
  
end
























