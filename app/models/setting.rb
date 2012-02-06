class Setting < ActiveRecord::Base

  def self.default_printer
    find_value('printer')
  end

  def self.email_template
    find_value('order_email_template')
  end


  def self.find_value(value_name)
    setting = find(:first, :conditions => "name='#{value_name}'")
    unless setting.nil?
      return setting.value
    end
    ''
  end
  
end
