# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class HomeController < ApplicationController 
  include SslRequirement
  
  layout CURRENT_LAYOUT, :except => [:pickup_manifest, :pickup_details, :mark_picked_up, :mark_delivered]
  
  #before_filter :check_admin

  ssl_required :my_account

  caches_page :index
  caches_page :online_coupon, :noperc

  def when
  end	
  
  def index
    if @is_local and not session[:is_admin] 
      redirect_to :controller => 'admin', :action => 'login'
    elsif @is_local and session[:is_admin]
      redirect_to :controller => 'instore', :action => 'index'
    end
  end

  def contact
    
  end
  
  def pickup
    @logged_in = session[:logged_in]
    @user = session[:logged_in_user]
    @delivery_days = nil
    unless @user.nil?
      if DeliveryArea.zipcode_exists?(@user.zip)
        @delivery_days = DeliveryArea.delivery_days(@user.zip)
      end
    end
    
    @error = session[:login_error]
  end

  def forgot_password
  end  
  
  def online_coupon
  end
  
  def send_password
    @user = User.find_by_email(params['forgot_password']['email_address'])
    @email_address = params['forgot_password']['email_address']

    unless @user.nil?
      pickup_url = render_to_string :inline => "<%= pickup_url()%>"
      mail = Notifier.create_send_password(@user, pickup_url)  # => a tmail object
      Notifier.deliver(mail)
    end
    
  end
  
  def check_password
    user = User.find_by_email(params['login']['email_address'])
    unless user.nil?
      if user.password == params['login']['password']
        session[:logged_in] = true
        session[:logged_in_user] = user
      end
    else
      session[:login_error] = "#{params['login']['email_address']} wasn't found."
    end
    if params.key?('redirect')
      redirect_to :action => params['redirect']  
    else
      redirect_to :action => 'pickup'
    end

  end

  def schedule_pickup
    if !params.key?(:user_id)
      redirect_to :action => 'pickup'
      return
    end

    begin
      @user = User.find(params[:user_id])
      unless @user.nil?

        @delivery_days = nil
        unless @user.nil?
          if DeliveryArea.zipcode_exists?(@user.zip)
            @delivery_days = DeliveryArea.delivery_days(@user.zip)

            begin
              @pickup = Pickup.add_pickup(@user.id, @delivery_days, params[:login][:coupon_code])
            rescue Exception => e
            end

          end
        end

        mail = Notifier.create_schedule_pickup(@user, @pickup,
                params[:login][:coupon_code])  # => a tmail object
        Notifier.deliver(mail)
      end
    rescue
      redirect_to :action => 'pickup'
    end
    
  end


  def cancel_pickup
    begin
      if params.key?('cancel')
        @cancelling = true
        @pickup = Pickup.find(params['id'])
        Pickup.delete(params['id'])
        @cancelled = true
      else
        @pickup = Pickup.find(params['id'])
      end
    rescue Exception => ex
      @error = ex.message
    end
  end


  def pickup_details
    @pickup = Pickup.find(params['id'])
    @completed_pickup = CompletedPickup.find_by_pickup_id(@pickup.id)
    @delivery = Delivery.find_by_pickup_id(params['id'])

  end

  def mark_delivered
    now = DateTime.now - (1/8.0)
    @delivery = Delivery.create(:pickup_id => params['id'], :delivery_date => now)
    @delivery.save!
    @pickup = @delivery.pickup
  end

  def pickup_manifest
    manifest = Pickup.pickup_manifest
    @pickups = manifest[:today]
    @older = manifest[:older]
    d = DateTime.now - (1/8.0)
    @today = sprintf("%02d-%02d-#{d.year}", d.month, d.day)
  end

  def mark_picked_up
    @pickup = Pickup.find(params['id'])
    @user = @pickup.user
    @completed_pickup = CompletedPickup.find_by_pickup_id(@pickup.id)
    if @completed_pickup.nil?
      now = DateTime.now - (1/8.0)
      @completed_pickup = CompletedPickup.create(:pickup_id => @pickup.id, :pickup_date => now)
      @completed_pickup.save!
    end
  end

  def myaccount_update_password(params)
    current_password = params['password']['password']
    new_password = params['password']['new_password']  
    confirm_new_password = params['password']['confirm_new_password']
    user = User.find(params['password']['id'])

    @response = ''
    unless user.nil?
      if current_password.length == 0 || new_password.length == 0 || confirm_new_password.length == 0
        @response = 'Please fill in all password fields.'
      elsif current_password != user.password
        @response = "Incorrect current password."
      elsif new_password != confirm_new_password
        @response = "New passwords don't match."
      else
        User.update(user.id, :password => new_password)
        @response = "Password Updated"
      end
    end
    @response
  end
  
  def my_account
    @saved = ''
    @password_response = ''
    
    if params.key?('user')
      #update the user's information
      user = User.find(params['user']['id'])
      unless user.nil?

        begin
          User.update(user.id, params['user'])
          session[:logged_in_user] = User.find(params['user']['id'])

          cc_record = CcRecord.find_by_user_id(params['user']['id'])
          if cc_record.nil?
            @saved = "Couldn't find credit card information."
          else
            params['cc']['id'] = cc_record.id
            CcRecord.update(cc_record.id, params['cc'])
            @saved = "Information Saved"
          end
          
        rescue Exception => e
          @saved = e.message
        end
      end
    elsif params.key?('password')
      @password_response = myaccount_update_password(params)
    end
    
    @logged_in = session[:logged_in]
    @user = session[:logged_in_user]
    unless @user.nil?
      @cc_record = CcRecord.find_by_user_id(@user.id)
    end
  end

  def delete_from_manifest
    pickup = Pickup.find(params[:id])
    unless pickup.nil?
      pickup.delete
      redirect_to :action => 'pickup_manifest'
    else
      render :text => "Pickup not found"
    end

  end

  def test
    response.headers['Access-Control-Allow-Origin'] = 'http://swetonic.org/'
    render :text => 'Text from method test'
  end

  def js_call
    
  end

end








