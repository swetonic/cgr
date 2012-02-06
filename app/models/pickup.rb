require 'date'


class Pickup < ActiveRecord::Base
  belongs_to :user

  DELIVERY_DAYS = {'Monday' => 1, 'Tuesday' => 2, 'Wednesday' => 3,
                   'Thursday' => 4, 'Friday' => 5, 'Saturday' => 6}

  def self.pickup_manifest
    now = DateTime.now - (1/8.0)
    pickup_date_start = sprintf("#{now.year}-%02d-%02d 00:00:00", now.month,now.day)
    pickup_date_end = sprintf("#{now.year}-%02d-%02d 23:59:59", now.month,now.day)
    today_pickups = find(:all,
                         :conditions => "pickup_date > '#{pickup_date_start}' and pickup_date < '#{pickup_date_end}'")
    older_pickups = find(:all, :order => 'pickup_date desc',
      :conditions => "pickup_date < '#{pickup_date_start}' and pickup_date > '#{pickup_date_start}' - interval 14 day")

    {:today => today_pickups, :older => older_pickups}
    
  end

  def self.add_pickup(user_id, pickup_days, coupon_code)
    pickup = nil
    user = User.find(user_id)
    days = pickup_days.split(",")
    if days.length == 2 and user != nil
      days[1].lstrip!
      delivery_days = []

      delivery_days << DELIVERY_DAYS[days[0]]
      delivery_days << DELIVERY_DAYS[days[1]]

      puts "delivery_days: #{delivery_days.inspect}"

      now = DateTime.now - (1/8.0)
      today = now.wday

      puts "today: #{today} now: #{now}"

      if today >= delivery_days[1]
        #the pickup day will be delivery_days[0] in the next week
        days_to_add = (7 - today) + delivery_days[0] 

      elsif today >= delivery_days[0] and today < delivery_days[1]
        #the pickup day is delivery_days[1]
        days_to_add = delivery_days[1] - today 

      elsif today < delivery_days[0]
        #the pickup day is delivery_days[0]
        days_to_add = delivery_days[0] - today 

      end

      now += days_to_add

      pickup_date = sprintf("#{now.year}-%02d-%02d %02d:%02d:%02d", now.month,now.day, now.hour,now.min,now.sec)
      sql = "insert into pickups values(null,#{user_id},'#{pickup_date}',now(),now(),'#{coupon_code}');"
      connection.execute(sql)

      pickup = find(:first, :conditions => "user_id=#{user_id}", :order => 'pickup_date desc', :limit => 1)
      
    end

    return pickup
  end

end


