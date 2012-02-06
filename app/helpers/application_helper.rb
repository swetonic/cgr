# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  CURRENT_LAYOUT = 'main'
  TAX_RATE = 0.095

  def tax_rate
    TAX_RATE
  end

  def current_layout
    'main_alt'
  end

  def default_printer
    Setting.default_printer
  end
  
  def order_total(order)
    begin
      return "$#{order_total_plain(order)}"
    rescue Exception => e
      return ''
    end
  end

  def order_total_plain(order)
    total = 0.0
    order.order_items.each do |item|
      total += (item.unit_price * item.quantity * item.discount)
    end
    tax = TAX_RATE * total
    discounts = order_discount_total(order.id)
    sprintf("%.2f", total + tax - discounts)
  end

  def grand_total_with_tax(order)
    total = 0.0
    order.order_items.each do |item|
      total += (item.unit_price * item.quantity * item.discount)
    end
    tax = TAX_RATE * total
    sprintf("Subtotal: $%.2f<br>Tax: $%.2f<br>Grand Total: $%.2f", 
        total, tax, total + tax)
  end

  def all_orders_total_due(conditions = 'paid=0')
    total = 0.0

    Order.find(:all, :conditions => conditions).each do |order|
      begin
        order.order_items.each do |item|
          total += (item.unit_price * item.quantity * item.discount)
        end
        total -= order_discount_total(order.id)
      rescue Exception => e
      end
    end
    total += (total * TAX_RATE)
    return sprintf("$%.2f", total)
  end

  def order_total_due(user_id)
    total = 0.0
    
    Order.find(:all, :conditions => ['paid=0 and user_id=?', user_id]).each do |order|
      order.order_items.each do |item|
        item_total = (item.unit_price * item.quantity * item.discount)
        item_total += (item_total*TAX_RATE)
        total += item_total
      end
    end
    sprintf("$%.2f", total)
  end
  
  def customer_name(user)
    "#{user.first_name} #{user.last_name}"
  end

  def customer_name_by_order(order)
    user = User.find(order.user_id)
    "#{user.first_name} #{user.last_name}"
  end

  def date_format(date)
    date.strftime("%m/%d/%y %I:%M %p")
  end

  def date_format_short(date)
    date.strftime("%m/%d/%y")
  end

  def customer_has_open_orders?(user_id)
    orders = Order.find(:all, :conditions => ['user_id=? and paid=0', user_id])
    return orders.size > 0  
  end
  

  def discount_text(discount_multiplier)
    discount = (1 - discount_multiplier) * 100
    "#{sprintf("%2.0f", discount)}% discount"
  end

  def order_paid_on(order)
    payment = Payment.find(:first, :conditions => ["order_id=?", order.id])
    payment.created_on.strftime("%m/%d/%y")
  end

  def order_receipt_header
    p = PDF::Writer.new(:orientation => :landscape)
    
    p.select_font 'Helvetica'
    p.font_size = 12
    
    cur_top = receipt_top() - 95
    line_height = receipt_line_height
    
    filename = "#{RAILS_ROOT}/public/images/cgr-logo-laundry-bag.jpg"
    p.add_image_from_file(filename, receipt_margin, cur_top, 100)
    p.add_image_from_file(filename, receipt_middle, cur_top, 100)
    
    address = receipt_address
    
    cur_top = 550
    address_left = [
      {:text => address[0], :top => cur_top},
      {:text => address[1], :top => cur_top-(line_height*1)},
      {:text => address[2], 
        :top => cur_top-(line_height*2)}   ]
    
    address_left_x = 125 + receipt_margin_addition
    
    address_left.each do |text|
      p.add_text(address_left_x, text[:top], text[:text])
    end
    
    address_left_x = 515 + receipt_margin_addition
    
    address_left.each do |text|
      p.add_text(address_left_x, text[:top], text[:text])
    end

    p
    
  end

  def generate_receipt(order)
    #generate a pdf file as a receipt
    p = order_receipt_header
    add_order_items(p, order)
    
    filename = "#{orders_receipts_dir()}/order-#{order.id}.pdf"
    p.render
    p.save_as(filename)
    order.order_receipt = filename
    order.save!
    
  end

  def generate_payment_receipt(order, payment_record)
    #generate a pdf file as a receipt
    p = order_receipt_header
    cur_top = add_order_items(p, order) - receipt_line_height
    
    #now add the payment info
    lines = []
    lines << "Payments"
    
    payments = Payment.payments_made(order.id)
    payments.each do |pmt|
      lines << format_payment(pmt)
    end
    
    lines.each do |line|
      p.add_text(receipt_margin, cur_top, line) 
      p.add_text(receipt_middle, cur_top, line)
      cur_top -= receipt_line_height
    end
    
    filename = "#{payments_receipts_dir()}/payment-#{order.id}.pdf"
    payment_record.payment_receipt = filename
    payment_record.save!
    
    p.render
    p.save_as(filename)
    
  end

  private  
    def receipt_margin_addition
      setting = Setting.find(:first, 
        :conditions => "name='receipt_margin_addition'")
      unless setting.nil?
        return setting.value.to_i
      end
      0
    end
    def receipt_margin
      20 + receipt_margin_addition
    end
    
    def receipt_middle
      410 + receipt_margin_addition
    end

    def receipt_top
      600
    end
    
    def receipt_line_height
      12
    end

    def payment_method(method)
      case method
        when 1
          'Cash'
        when 2
          'Check'
        when 3
          'Credit Card'
        when 4
          'Debit Card'
        else
          ''
      end
    end
    
  def add_order_items(receipt_pdf, order)
    line_height = 12
    
    receipt_pdf.font_size = 12
    cur_top = 465

    lines = []
    notes = []
    
    lines << "Customer: #{customer_name(order.user)}"
    lines << "Order # #{order.id}"
    lines << "Date: #{date_format_short(order.created_on)}"
    
    if order.date_needed != ''
      lines << "Date Needed: #{order.date_needed}"
    end
    
    lines << ''
    
    order.order_items.each do |item|
      if item.description.length > 0
        notes << "#{item.cleaning_category_item.name} description: #{item.description}"
      end

      category_name = ''
      if item.cleaning_category_item.cleaning_category != nil
        category_name = item.cleaning_category_item.cleaning_category.name
      end
      
      line = "#{category_name} : #{item.cleaning_category_item.name}    " +
                  "#{item.quantity} @ #{sprintf("$%.2f", item.unit_price*item.discount)} = "
      if item.discount != 1
        line += "(#{discount_text(item.discount)})"
      end
      line += " #{sprintf("$%.2f", item.quantity*item.unit_price*item.discount)}"
      lines << line
    end

    lines << "Sales Tax:               $#{compute_tax(order)}"
    lines << ""
    

    lines.each do |line|
      receipt_pdf.add_text(receipt_margin, cur_top, line)
      receipt_pdf.add_text(receipt_middle, cur_top, line)
      cur_top -= line_height
    end
    
    lines.clear
    
    lines << "Total:                 $#{order_total_plain(order)}"
    receipt_pdf.select_font 'Helvetica-Bold'
    lines.each do |line|
      receipt_pdf.add_text(receipt_margin, cur_top, line)
      receipt_pdf.add_text(receipt_middle, cur_top, line)
      cur_top -= line_height
    end

    lines.clear
    lines << ""
    lines << "You got #{no_perc_points(order.id)} \"No PERC perk points\" for this order."
    lines << "You now have #{user_perc_points(order.user.id)} \"No PERC perk points.\""
    lines << ""
    lines << ""
    lines << "Notes:"
    lines.concat(notes)
    
    receipt_pdf.select_font 'Helvetica'
    lines.each do |line|
      receipt_pdf.add_text(receipt_margin, cur_top, line)
      receipt_pdf.add_text(receipt_middle, cur_top, line)
      cur_top -= line_height
    end

    cur_top
  end

  def user_perc_points(user_id)
    points = NoPercPoint.find(:all, :conditions => ['user_id=?', user_id], 
        :select => 'sum(points)')
    points[0].attributes['sum(points)']  
  end
  
  def no_perc_points(order_id)
    num_points = 0
    points = NoPercPoint.find(:all, :conditions => ["order_id=?", order_id])
    points.each {|point| num_points += point.points}
    num_points
  end

  def no_perc_points_for_user(user_id)
    num_points = 0
    points = NoPercPoint.find(:all, :select => "sum(points)", 
        :conditions => ["user_id=?", user_id])
    points[0]['sum(points)'].to_i
  end

  def items_with_prices(category_items)
    longest = 0
    items = []
    category_items.each do |item|
      if item[0].length > longest
        longest = item[0].length
      end
      items << item[0]
    end
    
    length = longest + 4
    items.each_with_index do |item, index|
      (length - item.length).times do |idx|
        items[index] += "."
      end
      items[index] += sprintf("%.2f", category_items[index][2])
      category_items[index][0] = items[index]
    end
    
  end
  
  def is_local?
    return session[:is_local] == 'true'
  end
  
  def item_price(item)
    if delivery_customer?
      price = item.delivery_price
    else
      price = item.price
    end
    sprintf("$%.2f", price)
  end
  
  def delivery_customer?
    if session[:user]
      return session[:user].delivery_customer
    end
    
    false
  end

  def orders_total(orders)
    total = 0.0
    
    orders.each do |order|
      order.order_items.each do |item|
        total += (item.unit_price * item.quantity * item.discount)
      end
    end
    total
  end
  
  def sales_tax_total(orders)
    sales_tax = 0.0
    
    orders.each do |order|
      order.order_items.each do |order_item|
        cost = order_item.quantity.to_f * order_item.unit_price.to_f * order_item.discount.to_f
        tax = cost * tax_rate
        sales_tax += tax
      end
    end
    
    sales_tax
    
  end  
  
  def get_verify_url
    session[:verify_url]
  end

  def format_payment(pmt)
    "#{pmt.payment_date.strftime("%m/%d/%Y")} #{sprintf("$%.2f", pmt.amount)} #{payment_method(pmt.payment_method)}"
  end

  def format_payment_td(pmt)
    "<td>#{pmt.payment_date.strftime("%m/%d/%Y")}</td><td>#{sprintf("$%.2f", pmt.amount)}</td><td>#{payment_method(pmt.payment_method)}</td>"
  end

  def amount_due(order_items, payments, order_id)
    total = 0.0
    order_items.each do |item|
      total += (item.unit_price * item.quantity * item.discount)
    end
    tax = TAX_RATE * total
    
    total += tax
    paid = 0.0
    payments.each { |pmt| paid += pmt.amount }
    paid += order_discount_total(order_id)
    total - paid
  end

  def amount_due_s(order_items, payments, order_id, is_deposit=false)
    due = amount_due(order_items, payments, order_id)
    if is_deposit
      due /= 2
    end
    sprintf("%.2f", due)
  end

  def amount_due_formatted(order, payments)
    sprintf("$%.2f", amount_due(order.order_items, payments, order.id))
  end

  def store_name
    name = Setting.find(:first, :conditions => "name='store_name'")
    name.value
  end

  def order_discount_total(order_id)
    OrderDiscount.order_discount_total(order_id)
  end

  def picked_up_status(pickup_id)
    CompletedPickup.status(pickup_id)
  end

  def delivery_status(pickup_id)
    Delivery.status(pickup_id)
  end

private
  def receipt_address
    address = []
    addr = Setting.find(:first, :conditions => "name='receipt_address1'")
    address << addr.value
    addr = Setting.find(:first, :conditions => "name='receipt_address2'")
    address << addr.value
    addr = Setting.find(:first, :conditions => "name='receipt_address3'")
    address << addr.value
    
    address
    
  end
end












