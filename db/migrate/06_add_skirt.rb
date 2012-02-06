class AddSkirt < ActiveRecord::Migration
  
  def self.up
    cat = CleaningCategoryItem.create(:id => 48, :cleaning_category_id => 3,
              :name => 'Skirt', :price => 5.5, :delivery_price => 6.5)
    cat.save!
  end

  def self.down
    cat = CleaningCategoryItem.find(48)
    cat.destroy
  end
  
end
