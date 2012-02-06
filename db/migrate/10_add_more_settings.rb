class AddMoreSettings < ActiveRecord::Migration
  
  def self.up
    setting = Setting.create(:name => 'receipt_margin_addition', 
        :value => '0')
    setting.save!
  end

  def self.down
    setting = Setting.find(:first, :conditions => "name='receipt_margin_addition'")
    setting.destroy
  end
  
end

