# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.


class OrderController < ApplicationController
  
  PAYMENT_METHOD_CASH = 1
  PAYMENT_METHOD_CHECK = 2
  PAYMENT_METHOD_CREDIT = 3
  PAYMENT_METHOD_DEBIT = 4

  PAYMENT_TYPES = {'cash' => PAYMENT_METHOD_CASH,
    'credit' => PAYMENT_METHOD_CREDIT,
    'check' => PAYMENT_METHOD_CHECK,
    'debit' => PAYMENT_METHOD_DEBIT
  }
  
  layout CURRENT_LAYOUT

  def open_orders
    @orders = Order.find(:all, :conditions => 'paid=0', :order => 'created_on desc')
  end

  def deleted_orders
    @deleted_orders = DeletedOrder.find(:all)
  end
  
  def paid_orders
    @orders = Order.find(:all, :conditions => 'paid=1', :order => 'created_on desc')
  end

  def todays_paid_orders
    payment_date = Time.now.strftime("created_on >= '%Y-%m-%d'")
    payments = Payment.find(:all, :conditions => payment_date)

    @orders_total = 0.0
    @tax_total = 0.0
    @grand_total = 0.0
    @payments = {:check => [], :credit => [], :cash => []}
    @orders = []
    
    payments.each do |payment|
      @grand_total += payment.amount
      @orders_total += (payment.amount - payment.tax)
      @tax_total += payment.tax
      
      case payment.payment_method
        when PAYMENT_METHOD_CASH 
          @payments[:cash] << payment
        when PAYMENT_METHOD_CHECK 
          @payments[:check] << payment
        when PAYMENT_METHOD_CREDIT 
          @payments[:credit] << payment
        when PAYMENT_METHOD_DEBIT 
          @payments[:credit] << payment
      end
      
      @orders << Order.find(payment.order_id)
      
    end
    
#    @orders = Order.find(:all, 
#        :conditions => "paid=1 and #{payment_date}", :order => 'created_on desc')
  end
  
  def apply_discount
    if params[:discount].to_f != 1.0
      order = Order.find(params[:id])
      order.order_items.each do |item|
        item.discount = params[:discount].to_f
        item.save!
      end
    elsif params['coupon_amount'] != ''
      #apply a flat discount to the entire order
      discount = OrderDiscount.create(:order_id => params[:id], 
                :amount => params['coupon_amount'].gsub(/[^\d\.]/, ''))
      discount.save!
    end
    
    redirect_to :action => 'view_order', :id => params[:id]
    
  end

  def print_receipt
    order = Order.find(params[:id])
    if not File.exists?(order.order_receipt)
      render :update do |page|
        msg = "'The receipt #{order.order_receipt} was not found'"
        page << "alert(#{msg});"
      end
    else
      open_pdf_file(order.order_receipt)
    end
  end

  def delete
    require_manager_approval
    @order = Order.find(params[:id])
  end
  
  def delete_order
    @error = nil
    begin
      if params['reason'] == ''
        raise Exception.new('Deleting an order requires a reason.')
      end
      
      check_approved_url
      
      @order = Order.find(params[:id])
      html = render_to_string(:partial => 'order_items', 
        :locals => {:order => @order, :order_items => @order.order_items})
      deleted_order = DeletedOrder.create(:html => html, 
        :reason => params['reason'], :admin_id => session[:admin_id])
      deleted_order.save!
      
      @order.order_items.each { |order_item| order_item.destroy }
      
      @order.destroy
      log_user_action("order #{params[:id]} deleted.")
        
    rescue Exception => e
      @error = e.message
    end
    reset_manager_auth_state
  end
  
  def view_order
    @is_deposit = params.key?('deposit')
    @order = nil
    @tax = ''
    begin
      @order = Order.find(params[:id])
      @tax = compute_tax(@order)
      @order_items = @order.order_items
      @order_discounts = @order.order_discounts
      @user = @order.user
      @order_payments = Payment.payments_made(@order.id)
    rescue Exception => e
    end
  end

  def view_user_orders
    @user = User.find(params[:id])
    @orders = Order.find(:all, :conditions => ['user_id=? and paid=0', params[:id]])
  end

  def find_order
    redirect_to :action => 'view_order', :id => params[:order][:id]
  end

  def make_payment
    @error = nil
    @order = Order.find(params['order_id'])
    
    if params.key?('payment')
      begin
        if @order.paid?
          @error = "Order #{@order.id} has already been paid."
        else
          payment = Payment.create(
            :payment_method => PAYMENT_TYPES[params['payment']['type']],
            :order_id => params['order_id'],
            :amount => params['payment_amount'],
            :admin_id => session[:admin_id],
            :payment_date => Time.now,
            :tax => params['tax'])
          payment.save!

          if payment.payment_method == PAYMENT_METHOD_CHECK
            payment.check_num = params['check_number']
            payment.save!
          end
          
          total_due = order_total_float(@order)
          if params['payment_amount'].to_f >= total_due
            @order.paid = 1 
          else
            payments_made = Payment.payments_made_sum(@order)
            if (payments_made + params['payment_amount'].to_f) >= total_due
              @order.paid = 1 
            end
          end
          
          generate_payment_receipt(@order, payment)

          @order.save!
        end      
      rescue Exception => e
        @error = e.message
      end
    else
      @error = "Please select a payment type."
    end
  end

  def edit
    # set up variables needed to display the order
    require_manager_approval
    
    view_order
    set_category_items
    set_common_items
    order_items = set_order_items

    if @manager_redirect.nil?
      # render the order's items to html, which will be displayed in the partial
      # in edit.erb
      @order_items_html = render_to_string :partial => 'instore/order_items', 
        :locals => {:order_items => order_items, :show_remove => true}
    end
    
  end

  def update_order
    check_approved_url
    
    Order.delete_order_items(params['order_id'])
    @id = params['order_id']
    
    #TODO: use delivery price when appropriate
    session[:order_items].each do |key, item|
      new_item = OrderItem.create(:order_id => params['order_id'].to_i, 
            :cleaning_category_item_id => item[:category_item].id, 
            :quantity => item[:quantity],
            :description => item[:description], 
            :unit_price => item[:category_item].price, 
            #:unit_price => item[:cost],
            :discount => item[:discount], 
            :admin_id => session[:admin_id])
      if new_item[:unit_price] == 0
        new_item[:unit_price] = item[:cost] / item[:quantity]
      end
      new_item.save!
    end
    
    date_needed = session[:date_needed]
    if date_needed != ''
      order = Order.find(params['order_id'])
      order.date_needed = date_needed
      order.save!
    end
    
    order = Order.find(params['order_id'])
    generate_receipt(order)
    @msg = 'Your order was updated'
    reset_manager_auth_state
    log_user_action("Order #{params['order_id']} updated.")
    
  end

  def order_history
    @user = User.find(params[:id])
    @orders = Order.find(:all, :conditions => ["user_id=?", params[:id]])
  end
  
  def print_payment_receipt
    payment = Payment.find(:first, 
        :conditions => ["order_id=?", params[:id]])
    unless payment.payment_receipt.nil?
      open_pdf_file(payment.payment_receipt)
    end  
  end

  def set_date_needed
    session[:date_needed] = params['date_needed']
    render :text => 'Success'
  end

private
  def set_order_items
    order_items = []
    
    session[:order_items] = {}
    
    @order_items.each do |order_item|
      cci = CleaningCategoryItem.find(order_item.cleaning_category_item_id)
      item = {  :category_item => cci,
                        :cost => order_item.unit_price * order_item.quantity,
                        :category => CleaningCategory.find(cci.cleaning_category_id),
                        :quantity => order_item.quantity,
                        :discount => order_item.discount,
                        :date_needed => @order.date_needed,
                        :description => order_item.description}
      order_items << item
      session[:order_items][item.object_id.to_s] = item
    end
    order_items
  end
  
end









