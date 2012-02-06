class ReportsController < ApplicationController 
  
  layout 'report'
  
  def update_daily_report
    set_report_vars(params['month'].to_i, params['day'].to_i, params['year'].to_i)
    html = render_to_string :partial => 'daily_report_content'
    render :update do |page|
      page.replace_html 'report_content', html
    end
  end
  
  def daily_report
    set_report_vars
  end

  def monthly_reports
    @months = Payment.get_payment_months
  end
  
  def monthly_report
    month_num = params['month_num'].to_i
    year_num = params['year'].to_i
    
    payments = Payment.get_payments_by_month(month_num, year_num)
    total_income = 0.0
    payments.each { |pmt| total_income += pmt.amount }
    @report_title = sprintf("Monthly Report for #{MONTH_NAMES[month_num-1]}, #{year_num}")
    @num_payments = payments.length
    alterations_total = Payment.get_alterations_by_month(month_num, year_num)
    @alterations_total = sprintf("$%.2f", alterations_total)
    @total_income = sprintf("$%.2f", total_income + alterations_total)
    @orders_opened = Order.order_count_by_month(month_num, year_num)
    @item_detail = Order.paid_order_items_by_month(month_num, year_num)
                
  end

    
  private

  def set_report_vars_old(month=nil, day=nil, year=nil)
    if month == nil and day == nil and year == nil
      @date = date_format_short(Time.now)
    else
      @date = sprintf("%02d/%02d/%02d", month, day, year - 2000)
    end

    @dc_cash = 0.0
    @dc_check = 0.0
    @dc_credit = 0.0
    @alteration_cash = 0.0
    @alteration_credit = 0.0
    @alteration_check = 0.0
    
    
    alterations_total = 0.0
    drycleaning_total = 0.0
    
    sales_tax_total = 0.0
    credit_card_payments = 0.0
    cash_payments = 0.0
    check_payments = 0.0
    
    if month == nil and day == nil and year == nil
      payments = Payment.find_payments_by_date(Time.now.strftime("%Y-%m-%d"))
    else
      payments = Payment.find_payments_by_date(sprintf("%d-%02d-%02d", year, month, day))
    end
    
    @num_payments = payments.size
    payments.each do |payment|
      amounts = Order.get_item_amounts(payment.order_id)
      alterations_total += amounts[:alterations]
      drycleaning_total += amounts[:dry_cleaning]
      sales_tax_total += payment.tax
      
      is_alteration = false
      is_dc = false
      if amounts[:alterations] > 0.0
        is_alteration = true
      end

      if amounts[:dry_cleaning] > 0.0
        is_dc = true
      end
      
      case payment_method(payment.payment_method)
        when 'Cash'
          cash_payments += payment.amount
          if is_dc
            @dc_cash += payment.amount
          end
          if is_alteration
            @alteration_cash += payment.amount
          end
        when 'Check'
          check_payments += payment.amount
          if is_dc
            @dc_check += payment.amount
          end
          if is_alteration
            @alteration_check += payment.amount
          end
        when 'Credit Card'
          credit_card_payments += payment.amount
          if is_dc
            @dc_credit += payment.amount
          end
          if is_alteration
            @alteration_credit += payment.amount
          end
        when 'Debit Card'
          credit_card_payments += payment.amount
          if is_dc
            @dc_credit += payment.amount
          end
          if is_alteration
            @alteration_credit += payment.amount
          end
      end

    end
    
    @alterations_total = sprintf("$%.2f", alterations_total)
    @drycleaning_total = sprintf("$%.2f", drycleaning_total)
    @sales_tax_total = sprintf("$%.2f", sales_tax_total)
    @credit_card_payments = sprintf("$%.2f", credit_card_payments)
    
    @check_payments = sprintf("$%.2f", check_payments)
    @cash_payments = sprintf("$%.2f", cash_payments)
    
    @cash_check_payments = sprintf("$%.2f", cash_payments + check_payments)
    #break out into sales/tax
    
    
    @total_payments = sprintf("$%.2f", credit_card_payments + cash_payments + check_payments)

    @dc_cash_check = sprintf("$%.2f", @dc_cash + @dc_check)
    @dc_cash = sprintf("$%.2f", @dc_cash)
    @dc_check = sprintf("$%.2f", @dc_check)
    @dc_credit = sprintf("$%.2f", @dc_credit)
    @alteration_cash_check = sprintf("$%.2f", @alteration_check + @alteration_cash)
    @alteration_cash = sprintf("$%.2f", @alteration_cash)
    @alteration_credit = sprintf("$%.2f", @alteration_credit)
    @alteration_check = sprintf("$%.2f", @alteration_check)
    
    
  end

  def set_report_vars(month=nil, day=nil, year=nil)
    if month == nil and day == nil and year == nil
      @date = date_format_short(Time.now)
    else
      @date = sprintf("%02d/%02d/%02d", month, day, year - 2000)
    end

    
    if month == nil and day == nil and year == nil
      payments = Payment.find_payments_by_date(Time.now.strftime("%Y-%m-%d"))
    else
      payments = Payment.find_payments_by_date(sprintf("%d-%02d-%02d", year, month, day))
    end
    
    alterations_total = 0.0
    drycleaning_total = 0.0
    sales_tax_total = 0.0
    cashcheck_payments = 0.0
    credit_card_payments = 0.0
    grand_total = 0.0
    
    @num_payments = payments.size
    payments.each do |payment|
      amounts = Order.get_item_amounts(payment.order_id)
      alterations_total += amounts[:alterations]
      drycleaning_total += amounts[:dry_cleaning]
      total_sales_this_payment = amounts[:alterations] + amounts[:dry_cleaning]
      sales_tax_total += payment.tax
      grand_total += total_sales_this_payment + payment.tax
        
      is_alteration = false
      is_dc = false
      if amounts[:alterations] > 0.0
        is_alteration = true
      end

      if amounts[:dry_cleaning] > 0.0
        is_dc = true
      end
      
      case payment_method(payment.payment_method)
        when 'Cash'
          cashcheck_payments += total_sales_this_payment
        when 'Check'
          cashcheck_payments += total_sales_this_payment
        when 'Credit Card'
          credit_card_payments += total_sales_this_payment
        when 'Debit Card'
          credit_card_payments += total_sales_this_payment
      end

    end
    
    @alterations_total = sprintf("$%.2f", alterations_total)
    @drycleaning_total = sprintf("$%.2f", drycleaning_total)

    @cashcheck_tax = sprintf("$%.2f", cashcheck_payments * TAX_RATE)
    @credit_card_tax = sprintf("$%.2f", credit_card_payments * TAX_RATE)
    @credit_card_payments = sprintf("$%.2f", credit_card_payments)
    @cashcheck_payments = sprintf("$%.2f", cashcheck_payments)
    @grand_total = sprintf("$%.2f", grand_total)
    @sales_tax_total = sprintf("$%.2f", sales_tax_total)
    
  end
  
end


