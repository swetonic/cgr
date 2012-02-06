
class CleaningCategory < ActiveRecord::Base
  has_many :cleaning_category_items
  
  
  def self.category_names
    find(:all, :select => 'name').collect { |cat| cat.name }
  end
  
  def self.find_by_name(name)
    find(:first, :conditions => ['name=?', name])
  end
  
  def self.is_alterations_category(id)
    category = find(id)
    return category.name == 'Alterations'
  end

  def self.is_custom_alteration(category_id, category_item_id)  
    if self.is_alterations_category(category_id)
      return CleaningCategoryItem.is_custom_alteration_item(category_item_id, category_id)
    end
    false
  end
  
end
