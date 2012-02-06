# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.


#let’s say you want to print all of the pdf files in a directory quickly.  printing from the command line in these situations can be handy.  here’s how to do it:
#
#     >> lpstat -a 
#
# will give you a list of all of the installed printer names.
#
#    >> lp -d “my_printer_name” ~/my_folder/*.pdf 
#
#will send out all of those pdf files to be printed! 

# %x[lpstat -a]

require_dependency 'password'


class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  MONTH_NAMES = ['January', 'February', 'March', 'April', 'May', 'June', 'July',
    'August', 'September', 'October', 'November', 'December' ]

  TAX_RATE = 0.095

  DEFAULT_CATEGORY = 'Dry Cleaning'
  READER_PATH = "\"/Applications/Adobe Reader 8/Adobe Reader.app/Contents/MacOS/AdobeReader\""
  
  before_filter :check_domain
  
  include ApplicationHelper
  
  def open_pdf_file(filename)
    cmd_line = "#{READER_PATH} #{filename}"
    IO.popen(cmd_line)
  end

  def log_user_action(description)
    action = UserAction.create(:admin_id => session[:admin_id], 
        :description => description)
    action.save!
  end
  
  def order_total_float(order)
    begin
      return order_total_plain(order).to_f
    rescue Exception => e
      return 0.0
    end
  end
  
  def check_approved_url
    if session[:manager_approved_url].nil?
      raise Exception.new('There was an error: no approved url.')
    end
    
    start_pos = (request.referer.length - session[:manager_approved_url].length)
    compare_url = request.referer[start_pos, session[:manager_approved_url].length]
    if session[:manager_approved_url] != compare_url
      raise Exception.new('There was an error: unauthorized url.')
    end

  end
  
  def reset_manager_auth_state
    session[:manager_approved] = nil
    session[:manager_approved_url] = nil
  end
  
  def require_manager_approval
    if session[:manager_approved].nil?
      redirect_to :controller => 'user', :action => 'manager_login',
          :url => request.path
      @manager_redirect = true
    end
  end
  
  def admin_name
    session[:admin_user].nil? ? '' : session[:admin_user]
  end
  
  def place_order
    @error = nil
    if session[:order_items].empty?
        @error = 'Invalid Order. Please start over.'
    else
      @user = User.find(params['user_id'])
      @order_items = []
      for item in session[:order_items]
        @order_items << item[1]
      end
      session[:order_items].clear
      
      admin_id = session[:admin_id]
      @order = Order.create(:user_id => @user.id, :admin_id => admin_id)
      @order.save!

      date_needed = ''
      date_needed = session[:date_needed] unless session[:date_needed].nil?
      order_total = 0.0
      @order_items.each do |order_item|
        unless order_item[:date_needed].nil?
          date_needed = order_item[:date_needed]
        end
        
        unit_price = order_item[:category_item][:price]
        if @user.delivery_customer?
          unit_price = order_item[:category_item][:delivery_price]
        end
        if unit_price == 0.0
          #this happens with custom alteration items
          unit_price = order_item[:unit_price]
        end
        
        new_order_item = OrderItem.create(:order_id => @order.id, 
          :cleaning_category_item_id => order_item[:category_item][:id],
          :quantity => order_item[:quantity],
          :discount => order_item[:discount],
          :admin_id => admin_id,
          :unit_price => unit_price,
          :description => order_item[:description])
        
        new_order_item.save!
        
        if new_order_item.unit_price == 0
          #custom item, add the price
          # needs to use unit price
          new_order_item.update_attribute(:unit_price, 
                    order_item[:unit_price])
        end
        
        order_total += new_order_item.quantity * new_order_item.unit_price * new_order_item.discount
      end
      @order.date_needed = date_needed
      @order.save!
      
      order_total += (order_total * tax_rate())
      points = order_total.to_i
      if order_total % 1 >= 0.1
        points += 1
      end
      
      perks = NoPercPoint.create(:user_id => @user.id, 
          :points => points, 
          :reason => 'order',
          :order_id => @order.id)
      perks.save!
      
      @order_total = order_total
      generate_receipt(@order)
      @print_result = ''

      @email_template = Setting.email_template
      
      if Setting.default_printer.length > 0
        @print_result = print_file(@order.order_receipt)
      else  
        redirect_to :controller => 'instore', :action => 'set_printer'
      end
    end
    
  end
  
  def check_domain
    @is_local = false
    if params.key?('is_local')
      if params['is_local'] == 'true'
        @is_local = true
      end
      session[:is_local] = @is_local.to_s
    elsif session[:is_local]
      @is_local = session[:is_local] == 'true'
    else
      @is_local = self.request.host == 'localhost'
    end
    session[:is_local] = @is_local.to_s
  end
    
  def check_admin
    if @is_local and session[:is_admin].nil?
      redirect_to :controller => 'admin', :action => 'login'
    end
  end

  def check_admin_2
    
    return if request.parameters['controller'] == 'admin' and request.parameters['action'] == 'login'
    return if request.parameters['controller'] == 'admin' and request.parameters['action'] == 'check_password'
    
    if @is_local or session[:is_local]
      if session[:is_admin].nil?
        redirect_to :controller => 'admin', 
              :action => 'login',
              :params => {:controller => request.parameters['controller'],
                          :action => request.parameters['action'] }
        return
      end
    end
  end

  def compute_tax(order)
    compute_tax_from_items(order.order_items)
  end

  def compute_tax_from_items(order_items)
    total = 0.0
    order_items.each do |item|
      total += (item.unit_price * item.quantity * item.discount)
    end
    sprintf("%.2f", TAX_RATE * total)
  end

  def receipts_dir
    '/Users/swetonic/Desktop/receipts'
  end
  
  def orders_receipts_dir
    "#{receipts_dir}/orders"
  end

  def payments_receipts_dir
    "#{receipts_dir}/payments"
  end

  def set_category_items
    categories = CleaningCategory.find(:all)
    @categories = []
    default = []
    categories.each do |cat|
      if cat.name == DEFAULT_CATEGORY
        default = [cat.name, cat.id]
      else
        @categories << [cat.name, cat.id]
      end
    end

    @categories.unshift(default)


    @category_items = []
    category_items = CleaningCategoryItem.get_items_by_category_name(DEFAULT_CATEGORY)
    category_items.each do |item|
      price = item.price
      price = item.delivery_price if @user.delivery_customer
      @category_items << [item.name, item.id, price]
    end
  end
  
  def set_common_items
    #common items displayed in new order page
    #all dry cleaniing items
    @common_items = []
    common_item_names = ['Blouse', 'Dress', 'Suit', 'Pants/Slacks']

    @common_items << CleaningCategoryItem.get_item('Laundry', 'Shirt')

    for name in common_item_names
      @common_items << CleaningCategoryItem.get_item('Dry Cleaning', name)
    end
  end
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  private
  def print_file(filename)
    #execute command to print filename
    cmd = "lp -o orientation-requested=4 -d \"#{default_printer()}\" #{filename}"
    result = `#{cmd}`
    if result =~ /request id is /
      "#{filename} is printing."
    else
      "#{filename} is NOT printing: #{result}."
    end
  end
  
end









