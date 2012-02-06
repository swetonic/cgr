
class User < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :phone
  has_many :no_perc_points
  has_many :orders
  
  attr_writer :verify_url
  attr_writer :local_user
  
  def self.find_by_email(email_address)
    find(:first, :conditions => ["email_address=?", email_address])
  end

  def self.add_users
    puts "Name,User Id,CC Num,Expiration,CVV,Zip Code"
    user_ids = "179,180,181,182,183,184,185,186,187,188,189,190,191"
    user_ids.split(",").each do |id|
      user = User.find(id)
      cc = CcRecord.find(:first, :conditions => "user_id=#{id}")
      puts "#{user.first_name} #{user.last_name},#{user.id},#{cc.cc},#{cc.expiration},#{cc.cvv},#{user.zip}"
    end
    ''
  end

  def self.add_users2
    user_ids = "208,209,210,211,212,213,214,215,216,217,218,219,220"
    user_ids.split(",").each do |id|
      user = User.find(id)
      cc = CcRecord.find(:first, :conditions => "user_id=#{id}")
      sql = "insert into users values(null, '#{user.first_name}', '#{user.last_name}','#{user.email_address}','#{user.password}',"
      sql += "'#{user.address1}','#{user.address2}','#{user.city}','#{user.state}','#{user.zip}','#{user.phone}',"
      sql += "'#{user.alternate_phone}','#{user.birthday}','#{user.referred_by}','#{user.shirt_laundry}','#{user.dry_cleaning}',"
      sql += "'#{user.laundry}',1,'#{user.howd_you_hear}','#{user.uuid}',0);"
      puts sql
    end
    ''
  end

  def validate_on_update
    if !@local_user
        if zip.empty? or address1.empty? or city.empty? or phone.empty?
          raise "Zip, address, city and phone must be filled in."
        end
    end
  end

end
