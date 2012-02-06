class CreateTshirtItem < ActiveRecord::Migration
  
  def self.up
    CleaningCategoryItem.create(:id => 45, :cleaning_category_id => 1, :name => 'T-Shirt', :price => 3.50, :delivery_price => 3.99)
  end

  def self.down
    item = CleaningCategoryItem.find(45)
    item.destroy
  end
  
end
