
namespace :cgr do

    desc "Send the daily email to CGR email addresses"
    task :daily_email => :environment do
      require 'activerecord'
	  Notifier.deliver(Notifier.create_daily_email)
    end
    


  namespace :db do
    
    desc "Generate migration statements for the default content in the database."
    task :dump_defaults => :environment do      
      require 'activerecord'
      
      puts "User.create(:first_name => 'tim', :last_name => 'swetonic', :phone => '206-390-9719')"
      
      #establish db connection, query for data
      ActiveRecord::Base.establish_connection
      
      Admin.find(:all).each do |admin|
        puts "Admin.create(:name => '#{admin['name']}', :password => '#{admin['password']}')"
      end

      CleaningCategory.find(:all).each do |category|
        puts "CleaningCategory.create(:id => #{category.id}, :name => '#{category.name}')"

        category.cleaning_category_items.each do |item|
          str = "CleaningCategoryItem.create(:id => #{item.id}, "
          str += ":cleaning_category_id => #{item.cleaning_category_id}, "
          str += ":name => '#{item.name}', "
          str += ":price => #{item.price}, "
          str += ":delivery_price => #{item.delivery_price})"
          puts str
        end
        
      end
      
    end
  end
end
