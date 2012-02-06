require 'pdf/writer'
require 'pdf/simpletable'


class InstoreController < ApplicationController 
  layout CURRENT_LAYOUT
  
  POINTS_PER_HANGER = 0.1
  
  include PDF::Writer::Graphics
  
  before_filter :check_local
  
  protect_from_forgery :only => []

  def add_employee
    if params['employee']['name'].length > 0
      Employee.add(params['employee']['name'])
    end
    
    redirect_to(:action => 'manage_employees')
  end

  def test
    render :text => EmployeeHour.can_punch_in.inspect 
  end

  def do_punchin
    EmployeeHour.punch_in(params['employee']['employee_id'])
    @employee = Employee.find(params['employee']['employee_id'])
  end

  def do_punchout
    EmployeeHour.punch_out(params['employee']['employee_id'])
    @employee = Employee.find(params['employee']['employee_id'])
  end


  def send_order_email
    @order = Order.find(params['order_id'])
    @user = User.find(params['user_id'])

    
    mail = Notifier.create_order_placed(@user, @order)  # => a tmail object
    Notifier.deliver(mail)

  end

  def punch_in

  end

  def punch_out

  end

  def employee_hours
    @employees = EmployeeHour.employees_in_db
  end

  def show_hours
    @employee = Employee.find(params['id'])
    @date_ranges = EmployeeHour.hours(params['id'])
  end
  
  def check_local
    if session[:is_local] != nil and session[:is_local] == 'false'
      redirect_to '/'
      return
    end
  end
  
  def manage_perc_points
    @users_points = NoPercPoint.users_and_points
  end

  
  def update_points
    points = params['points'].to_i
    message = ''
    begin
      if points == 0
        message = 'No points added'
      else
        user = User.find(params['user_id'].to_i)
        if user.nil?
          message = 'No points added - user not found'
        else
          NoPercPoint.add_points(user, points, "Manage PERC points: #{admin_name()}")
          message = "#{points} points added for #{customer_name(user)}"
        end
      end
    rescue Exception => e
      message = e.message
    end
    
    render :update do |page|
      page.replace_html 'status', message
    end
  end

  def redeem_hangers
    hangers = params['hangers'].to_i
    message = ''
    begin
      if hangers == 0
        message = 'No hangers redeemed'
      else
        user = User.find(params['user_id'].to_i)
        if user.nil?
          message = 'No points added - user not found'
        else
          points = POINTS_PER_HANGER * hangers
          if points % 1 != 0
            points += (1 - (points % 1))
          end
          
          NoPercPoint.add_points(user, points.to_i, "Manage PERC points: #{admin_name()}")
          message = "#{points} points added for #{customer_name(user)}"
        end
      end
    rescue Exception => e
      message = e.message
    end
    
    render :update do |page|
      page.replace_html 'status', message
    end
  end
  
  def index
    check_admin
  end

  
  def clear_order
    session[:order_items].clear
    session[:order_items] = nil
    session[:date_needed] = ''
    redirect_to :action => 'new_order', :id => params['user_id']
  end
  
  def new_order
    session[:order_items] = {}
    session[:date_needed] = ''
    
    @user = User.find(params[:id])
    session[:user] = @user unless @user.nil?
    
    set_category_items
    set_common_items
  
    items_with_prices(@category_items)
    options = ''
    
    for item in @category_items
      options += "<option value=\"#{item[1]}\">#{item[0]}</option>"
    end
    @category_options = options
  end
  
  def add_item_to_order
    if session[:order_items].nil?
      session[:order_items] = {}
    end

    date_needed = ''
    if params.key?('date')
      date_needed = params['date']['needed']
    end
   
    delivery_prices = false
    if params['delivery_customer'] == 'true'
      delivery_prices = true
    end
    
    order_items = []
    quantities = 0
    unless params['item']['quantity'] == ''
      quantities += params['item']['quantity'].to_i
      
      
      category_item = CleaningCategoryItem.find(params['category_items'])

      if delivery_prices == false
        cost = category_item.price
      else
        cost = category_item.delivery_price
      end

      category = CleaningCategory.find(category_item.cleaning_category_id)
      if CleaningCategory.is_custom_alteration(category.id, category_item.id)
        cost = params['item']['alteration_price'].to_f
        if cost == 0.0
          #error, show an error msg and return
          render :update do |page|
            page << "alert('Please Enter a Price for the Custom Alteration');"
          end
          return
        end
      end
      discount = params['discount'].to_f
      if params['discount'].to_f > 1.0
        item_cost = cost * params['item']['quantity'].to_i
        discount = 1 - (params['discount'].to_i / item_cost)
      end
      
      item = {  :category_item => category_item,
                        :cost => cost * params['item']['quantity'].to_i,
                        :category => category,
                        :quantity => params['item']['quantity'],
                        :discount => discount.to_f,
                        :date_needed => date_needed,
                        :description => params['item']['description']}
      
      if CleaningCategory.is_custom_alteration(category.id, category_item.id)
        item[:unit_price] = params['item']['alteration_price'].to_f
      end
      
      order_items << item
      session[:order_items][item.object_id.to_s] = item
    end
    
    params.keys.each do |key|
      if key.index('qty_') != nil && params[key]['count'] != ''
        quantities += params[key]['count'].to_i
        id = key[4, key.length - 4]
        category_item = CleaningCategoryItem.find(id)
        
        if delivery_prices == false
          cost = category_item.price
        else
          cost = category_item.delivery_price
        end
        
        discount = params['discount'].to_f
        if params['discount'].to_f > 1.0
          item_cost = cost * params[key]['count'].to_i
          discount = 1 - (params['discount'].to_i / item_cost)
          discount = 0 if discount < 0
        end
        
        category = CleaningCategory.find(category_item.cleaning_category_id)
        item = { :category_item => category_item,
                         :cost => cost * params[key]['count'].to_i,
                         :category => category,
                         :discount => discount,
                         :date_needed => date_needed,
                         :quantity => params[key]['count'],
                         :description => params['desc_' + id]['count']}
        order_items << item
        item[:index] = order_items.size - 1
      session[:order_items][item.object_id.to_s] = item
      end
    end
    
    #check for a custom item
    if params['custom']['count'] != ''
      custom_count = params['custom']['count'].to_i
      if custom_count > 0
        custom_price = params['custom']['price'].gsub(/[^\d\.]/, '')
        if custom_price == ''
          render :update do |page|
            page << "alert('Please enter a price for the custom item.');"
          end
          return
        else
            discount = params['discount'].to_f
            if params['discount'].to_f > 1.0
              item_cost = custom_price.to_f * custom_count
              discount = 1 - (params['discount'].to_i / item_cost)
            end

          quantities += custom_count
          category = CleaningCategory.find_by_name('Custom')
          category_item = category.cleaning_category_items[0]
          item = { :category_item => category_item,
                           :cost => custom_price.to_f * custom_count,
                           :unit_price => custom_price.to_f,
                           :category => category,
                           :discount => discount,
                           :date_needed => date_needed,
                           :quantity => custom_count,
                           :description => params['custom']['description']}
          order_items << item
          session[:order_items][item.object_id.to_s] = item
        end
      end
    end
    
    if quantities == 0
      render :update do |page|
        page << "alert('Please enter a quantity.');"
      end
    else
      html = ''
      begin
        html = render_to_string :partial => 'order_items', 
              :locals => {:order => nil, :order_items => order_items, :show_remove => true}
      rescue Exception => e
        html = e.message
      end
      
      total = order_total(session[:order_items])
      
      render :update do |page|
        page.insert_html :bottom, 'order_items', html
        page.replace_html 'order_total', total[:string]
        page << "$('clear_order').show();"
        page << "$('place_order').show();"
        page << "clearOrderFields();"
        if total[:float] > 50
          page << "$('deposit_note').show();"
        end
      end
    end
  end
  
  def update_other_items
    if(CleaningCategory.is_alterations_category(params['category_id']) and 
          CleaningCategoryItem.is_custom_item(params['category_item_id'], params['category_id']))
        render :text => 'yep'  
    else
      render :text => 'nope'
    end
  end
  
  def update_category_items
    category_items = []
    
    user = session[:user]
    if CleaningCategory.is_alterations_category(params['category_id'])
      #hack so Custom alterations item doesn't appear first
      items = CleaningCategoryItem.get_items(params['category_id'], :order => 'name desc')
    else
      items = CleaningCategoryItem.get_items(params['category_id'])
    end
    
    items.each do |item|
      price = item.price
      price = item.delivery_price if user.delivery_customer
      category_items << [item.name, item.id, price]
    end
    
    items_with_prices(category_items)
    options = ''
    
    for item in category_items
      options += "<option value=\"#{item[1]}\">#{item[0]}</option>"
    end
    render :text => options
  end
  
  def create
    @succeeded = false
    begin
      @user = User.create(params[:user])
      @user.local_user = true
      @user.save!
      @succeeded = true
    rescue Exception => e
      @exception = e.message
      return
    end
  end

  
  def new_customer
  end

  def update
    begin

      #these values need to be set, otherwise validation will fail
      if params['user']['zip'].empty?
        params['user']['zip'] = ' '
      end

      
      if params['user']['state'].empty?
        params['user']['state'] = ' '
      end

      if params['user']['address1'].empty?
        params['user']['address1'] = ' '
      end

      if params['user']['city'].empty?
        params['user']['city'] = ' '
      end

      if params['user']['phone'].empty?
        params['user']['phone'] = ' '
      end

      User.update(params['id'], params['user'])
      @user = User.find(params['id'])
      @message = 'Customer Saved'

      admin = Admin.find(session[:admin_id])
      num_points_to_add = params['no_perc_points'].to_i
      if params['no_perc_points'].to_i > no_perc_points_for_user(@user.id)
        num_points_to_add  -= no_perc_points_for_user(@user.id)
      else
        @user.no_perc_points.each do |pts|
          pts.destroy
        end
      end

      points = NoPercPoint.create(:points => num_points_to_add, 
        :user_id => @user.id, :reason => "Edit User (admin: #{admin.name})")
      points.save!
      
    rescue Exception => e
      @message = 'Customer Not Saved: ' + e.message
    end
  end
  
  def edit_customer
    @user = User.find(params[:id])
    @no_perc_points = 0
    @user.no_perc_points.each do |points|
      @no_perc_points += points.points
    end
  end
  
  def delete_customer
    @user = User.find(params[:id])
    unless @user.nil?
      @user.destroy
    end
  end
  
  def display_customer
    @user = User.find(params[:id])
  end
  
  def all_customers
    @users = []
    users = User.find(:all, :order => 'last_name asc')
    tmp_usr = []
    users.each do |u|
      tmp_usr << {:points => no_perc_points_for_user(u.id), :user => u}
    end
    
    @users = tmp_usr.sort {|a,b| b[:points] <=> a[:points]}
    
    @num_customers = @users.length
    render :template => 'instore/find_customer'
  end
  
  def find_customer
    @users = []
    
    search_param = nil
    if params['user']['last_name'] =~ /\(\d+\)/
      search_param = params['user']['last_name']
    elsif params['user']['phone'] =~ /\(\d+\)/
      search_param = params['user']['phone']
    elsif params['user']['email_address'] =~ /\(\d+\)/
      search_param = params['user']['email_address']
    end
    
    if search_param.nil?
      if params['user']['email_address'].length > 0
        @users = User.find(:all, 
            :conditions => ["email_address = ?", params['user']['email_address']])
      elsif params['user']['phone'].length > 0
        @users = User.find(:all, 
            :conditions => "phone like '%#{params['user']['phone']}%'")
      elsif params['user']['last_name'].length > 0
          @users = User.find(:all, 
              :conditions => ["last_name = ?", params['user']['last_name']])
      end
    else
      index = search_param =~ /\(\d+\)/
      end_index = search_param =~ /\)/
      id = search_param[index + 1, end_index - (index+1)] 
      @users << User.find(id)
    end
  
    if @users.size == 1
      action = 'display_customer'
      if params.key?('new_order')
        action = 'new_order'
      end
      redirect_to :action => action, :id => @users[0].id
    end
  end

  def remove_item_from_order
    session[:order_items].delete(params['object_id'])
    hide_clear_button = false
    if session[:order_items].size == 0
      hide_clear_button = true
    end
   
    total = order_total(session[:order_items])
    render :update do |page|
      page << "Element.remove($('#{params['element_id']}'))"
      if hide_clear_button
        page << "$('clear_order').hide();"
        page << "$('place_order').hide();"
        page.replace_html 'order_total', ''
      else
        page.replace_html 'order_total', total[:string]
      end
    end
  end

  def print_receipt
    order = Order.find(params[:id])
    if order.nil?
      
    else
      open_pdf_file(order.order_receipt)
    end
    
  end

  def set_printer
    @printers = []
    printers = %x[lpstat -a]
    printers.each_line { |line|  @printers << line.split(' ')[0]}
    @default_printer = Setting.default_printer
  end

  def save_printer
    @message = ''
    if params.key?('printer_name')
      setting = Setting.find(:first, :conditions => "name='printer'")
      if setting.nil?
        setting = Setting.create
      end
      setting.update_attributes(:name => 'printer', :value => params['printer_name'])
      @message = "#{params['printer_name']} is now saved as your printer."
    else
      @message = "printer_name wasn't found."
    end
  end
  
  def success
  end

  def add_points
    add_points_for_user(params['point']['value'].to_i, params[:id], 'add_points')
  end

  def referral
    add_points_for_user(100, params[:id], 'referral')
  end
  
  def spend_points
    add_points_for_user(-100, params[:id], params['point']['spend'])
  end

  private
  
  def add_points_for_user(points, user_id, reason)
    user = User.find(user_id)
    NoPercPoint.add_points(user, points.to_i, "#{reason}: by #{admin_name()}")
    verb = points > 0 ? 'added' : 'subtracted'
    session[:addpoints_message] = "#{points} points #{verb} for #{customer_name(user)}"
    redirect_to url_for(:action => :display_customer, :id => params[:id])
  end
  
  def order_total(order_items)
    return_hash = {}
    total = 0.0
    for item in order_items
      total += item[1][:cost]*item[1][:discount]
    end
    tax = total * TAX_RATE
    return_hash[:string] = sprintf("Subtotal: $%.2f<br>Tax: %.2f<br>Total: %.2f", 
        total, tax, total + tax)
    return_hash[:float] = total + tax
    return_hash
  end

  def compute_tax_from_session_items(order_items)  
    tax = 0.0
    order_items.each do |key,val|
      if val[:quantity].to_i > 0
        item_total = val[:cost].to_f * val[:discount].to_f
        tax += item_total * tax_rate
      end
    end
    sprintf("$%.2f", tax)
  end

end


