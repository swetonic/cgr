class AddSettings < ActiveRecord::Migration
  
  def self.up
    setting = Setting.create(:name => 'receipt_address1', 
        :value => 'Clean Green Revolution, LLC')
    setting.save!
    
    setting = Setting.create(:name => 'receipt_address2', 
        :value => '26112 Pacific Hwy. S')
    setting.save!

    setting = Setting.create(:name => 'receipt_address3', 
        :value => 'Kent, WA 98032     (206) 708-4308')
    setting.save!

    setting = Setting.create(:name => 'store_name', 
        :value => 'CGR Kent')
    setting.save!
  end

  def self.down
    setting = Setting.find(:first, :conditions => "name='receipt_address1'")
    setting.destroy

    setting = Setting.find(:first, :conditions => "name='receipt_address2'")
    setting.destroy

    setting = Setting.find(:first, :conditions => "name='receipt_address3'")
    setting.destroy

    setting = Setting.find(:first, :conditions => "name='store_name'")
    setting.destroy
  end
  
end

