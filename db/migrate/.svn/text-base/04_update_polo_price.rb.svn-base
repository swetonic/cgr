class UpdatePoloPrice < ActiveRecord::Migration
  
  def self.up
    item = CleaningCategoryItem.find(8)
    item.price = 4.5
    item.save!
  end

  def self.down
    item = CleaningCategoryItem.find(8)
    item.price = 5.5
    item.save!
  end
  
end
