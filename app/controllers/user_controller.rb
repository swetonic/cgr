# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require "rubygems"
require "uuid"

class UserController < ApplicationController 
  include SslRequirement
  
  ssl_required :verify
  ssl_required :signup, :create

  layout CURRENT_LAYOUT
  before_filter :check_admin

  caches_page :howto_join
  
  def test
    response = Notifier.deliver(Notifier.create_daily_email)
    render :text => response.inspect
  end

  def coupon_users
    count = 0.0
    matches = 0.0
    @non_matches = []
    @user_mapping = {}

    more_than_one_order = 0.0
    one_order = 0.0
    IO.readlines('/Users/swetonic/Desktop/couponUsers.csv').each do |line|
      parts = line.split(',')
      count += 1
      user = User.find(:first,
                       :conditions => "first_name like '%#{parts[0].gsub("'", "''")}%' and last_name like '%#{parts[1].gsub("'", "''")}%'")
      unless user.nil?
        puts matches += 1
        @user_mapping[user] = "#{parts[0]} #{parts[1]}"
        if user.orders.count > 1
          more_than_one_order += 1
        elsif user.orders.count == 1
          one_order += 1
        end
      else
        @non_matches << "#{parts[0]} #{parts[1]}"
      end


    end
    @one_order = "%.1f" % ((one_order/count)*100)
    #render :text => "#{matches} matches #{matches/count}<br>" + non_matches.join("<br>")
  end

  def howto_join
  
  end
  
  def manager_login
    log_user_action("manager login shown for #{params['url']}")
    session[:redirect_url] = params['url']
  end

  def verify_manager_login
    @error = ''
    
    hash = '1045982d842f3f96e84238c1e5c4d27c0b8a3dae2412a5119a2ff9826b51ed7479b24372a373ce1775f7d693c551790f15ae56371bbfe062bc5d5f5866acad40jcMcBLbz8RjB0EfAYrtpYO9naTfF8Hb1PK8QxS60lESV47Snpzrl4hlNIfHhDDPh'

    if Password.check(params['manager']['password'], hash)
      if session[:redirect_url].nil?
        @error = 'Error: no redirect url.'
      else
        url = session[:redirect_url]
        log_user_action("Manager login success. Destination: #{url}")
        session[:redirect_url] = nil
        session[:manager_approved] = true
        session[:manager_approved_url] = url
        redirect_to url
      end
    else
      log_user_action("Incorrect manager login. Password: #{Password.update(params['manager']['password'])}")
      @error = 'Incorrect Manager Password'
    end
  end
  
  def signup
    
  end
  
  def verify
    user = User.find(:first, :conditions => ["uuid=?", params['uuid']])
    @message = "Your account wasn't found."
    unless user.nil?
      user.verified = 1
      user.save!
      @message = "Your account has been verified."
    end
  end

  def success
    @in_area = session['in_area'] 
  end

  def create
    @exception = nil
    in_area = 1
    
    begin
      if params[:user][:email_address].length == 0
        @exception = 'Please enter an email address'
        return
      end

      user = User.find(:first, :conditions => ['email_address=?',  
          params[:user][:email_address]])
      
      if params[:user][:email_address] == ''
        @exception = "Please enter an email address"
      elsif params[:user][:password] == ''
        @exception = "Please enter a password"
      elsif params['cc']['info'] == ''
        @exception = "Please enter a credit card number"
      elsif params['cc']['expiration'] == ''
        @exception = "Please enter a credit card expiration date"
      elsif params['cc']['cvv'] == ''
        @exception = "Please enter a credit card CVV code"
      end

      unless user.nil?
        @exception = "#{params[:user][:email_address]} is already registered."
      end
      
      unless @exception.nil?
        return
      end
      
      @user = User.create(params[:user])
      uuid = UUID.generate.to_s
      @user.uuid = uuid
      @user.save!
      
      verify_url = render_to_string :inline => "<%= verify_url(:uuid => @user.uuid)%>"
      

      #encoded_cc = Password.update(params['cc']['info'])
      cc = params['cc']['info']

      cc_record = CcRecord.create(:user_id => @user.id, :cc => cc,
          :expiration => params['cc']['expiration'], :cvv => params['cc']['cvv'])
      cc_record.save!

      if not DeliveryArea.zipcode_exists?(@user.zip)
        in_area = 0
        Notifier.deliver(Notifier.create_user_followup(@user, "Customer isn't in our delivery area"))
      end

      Notifier.deliver(Notifier.create_account_verify(@user, verify_url))
      Notifier.deliver(Notifier.create_new_user(@user))

      cc_info_str = "#{cc} #{params['cc']['expiration']} #{params['cc']['cvv']}"
      Notifier.deliver(Notifier.create_cc_info(@user.id, cc_info_str))

    rescue Exception => e
      @exception = e.message
      return
    end
    session['in_area'] = in_area
    redirect_to :action => 'success'
  end
  

end
