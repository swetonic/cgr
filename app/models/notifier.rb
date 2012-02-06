class Notifier < ActionMailer::Base
  include ApplicationHelper

  COMPANY_NAME = "Clean Green Revolution, LLC"
  INFO_EMAIL_ADDR = 'info@cleangreenrevolution.com'
  INFO_EMAIL_ADDR_FULL = "#{COMPANY_NAME} <#{INFO_EMAIL_ADDR}>"

  def daily_email
    recipients ["swetonic@gmail.com", "info@cleangreenrevolution.com", "anne@cleangreenrevolution.com"]
    from       INFO_EMAIL_ADDR_FULL
    subject    "Daily Email"
    content_type  "text/html"
    body       
  end

  def signup_notification(user)
    #recipients 'info@cleangreenrevolution.com'
    recipients 'swetonic@gmail.com'
    bcc        ["swetonic@gmail.com"]
    from       INFO_EMAIL_ADDR_FULL
    subject    "Customer Signup"
    content_type  "text/html"
    body       :customer => user
  end
  
  def account_verify(user, verify_url)
    recipients user.email_address
    #bcc        ["swetonic@gmail.com", "info@cleangreenrevolution.com"]
    from       INFO_EMAIL_ADDR_FULL
    subject    "Please Verify Your Account with Clean Green Revolution"
    content_type  "text/html"
    body       :user => user, :url => verify_url
  end

  def new_user(user)
    recipients ["swetonic@gmail.com", "info@cleangreenrevolution.com"]
    from       INFO_EMAIL_ADDR_FULL
    subject    "New User via Web Site"
    content_type  "text/html"
    body       :user => user
  end

  def cc_info(user_id, cc_info)
    recipients ["swetonic@gmail.com", "anne@cleangreenrevolution.com"]
    from       INFO_EMAIL_ADDR_FULL
    subject    "New User cc info"
    content_type  "text/html"
    body       :user_id => user_id, :cc_info => cc_info
  end
  
  def schedule_pickup(user, pickup, coupon_code)
    recipients [user.email_address, 'info@cleangreenrevolution.com']
    bcc        ["swetonic@gmail.com"]
    from       INFO_EMAIL_ADDR_FULL
    subject    "Pickup Scheduled"
    content_type  "text/html"

    @delivery_days = nil
    if DeliveryArea.zipcode_exists?(user.zip) and user.email_address.index("@popcap.com") == nil 
      @delivery_days = DeliveryArea.delivery_days(user.zip)  
    end

    body       :user => user, :pickup => pickup, :coupon_code => coupon_code, :delivery_days => @delivery_days
  end

  def send_password(user, pickup_url)
    recipients [user.email_address]
    bcc        ["swetonic@gmail.com", "info@cleangreenrevolution.com"]
    from       INFO_EMAIL_ADDR_FULL
    subject    "Password Reminder"
    content_type  "text/html"
    body       :user => user, :pickup_url => pickup_url
  end

  def user_followup(user, reason)
    recipients ['swetonic@gmail.com', INFO_EMAIL_ADDR]
    from       INFO_EMAIL_ADDR_FULL
    subject   "Customer Followup Required"
    content_type  "text/html"
    body       :user => user, :reason => reason
  end

  def order_placed(user, order)
    recipients [user.email_address]
    bcc        ["swetonic@gmail.com", "info@cleangreenrevolution.com"]
    from       INFO_EMAIL_ADDR_FULL
    subject    "CGR Pickup Confirmation"
    content_type  "text/html"
    body       :user => user, :order => order


    attachment "application/pdf" do |a|
        a.body = File.read(order.order_receipt)
        a.filename = 'receipt.pdf'
    end
    
  end

end








