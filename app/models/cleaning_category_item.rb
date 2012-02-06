
class CleaningCategoryItem < ActiveRecord::Base
  belongs_to :cleaning_category

  def self.get_items(category_id, options=nil)
    db_opts = {:conditions => ['cleaning_category_id=?', category_id]}
    unless options.nil?
      db_opts.merge! options
    end
    find(:all, db_opts)
  end

  def self.get_item(category_name, item_name)
    id = CleaningCategory.find(:first, 
      :conditions => ['name=?', category_name],
      :select => 'id')
    find(:first, 
      :conditions => ['cleaning_category_id=? and name=?', id.id, item_name])
  end

  def self.get_items_by_category_name(category_name)
    category = CleaningCategory.find(:first, :conditions => ['name=?', category_name])
    unless category.nil?
      return get_items(category.id)
    end
    nil
  end

  def self.is_custom_item(id, category_id)
    item = find(:first, 
      :conditions => ['id=? and cleaning_category_id=?', id, category_id])
    return item.name == 'Custom'
  end
  
  def self.get_item_ids_by_category_names(category_names)
    item_ids = []
    category_names.each do |name|
      get_items_by_category_name(name).each {|item| item_ids << item.id}
    end
    item_ids
  end
  
  def self.is_custom_alteration_item(id, cleaning_category_id)
    item = find(id, 
      :conditions => ['cleaning_category_id=?', cleaning_category_id])
    
    unless item.nil?
      return item.name == 'Custom'
    end
    false
  end
  
  def self.get_item_ids_by_category_name(category_name)
    alteration_items = get_items_by_category_name(category_name)
    alteration_items.collect {|item| item.id}
  end

  def self.alteration_ids
    ids = get_item_ids_by_category_names('Alterations')
    return_ids = {}
    ids.each {|id| return_ids[id] = ''}
    return_ids
  end  
end






