class AddCustomCategory < ActiveRecord::Migration
  
  def self.up
    cat = CleaningCategory.create(:id => 9, :name => 'Custom')
    cat.save!
    
    cat2 = CleaningCategoryItem.create(:id => 47, :cleaning_category_id => 9,
              :name => 'Custom', :price => 0, :delivery_price => 0)
    cat2.save!
  end

  def self.down
    cat = CleaningCategory.find(9)
    cat.destroy
    cat2 = CleaningCategoryItem.find(47)
    cat2.destroy
  end
  
end
