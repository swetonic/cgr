class AdminController < ApplicationController 
  
  layout CURRENT_LAYOUT
  
  def login
    @retry = 0
    if params.key?('retry')
      @retry = 1
    end
  end
  
  def logout
    log_user_action("admin logout. id = #{session[:admin_id]}")
    session[:is_admin] = nil
    session[:admin_user] = nil
    session[:admin_id] = nil
    redirect_to :controller => 'home'
  end
  
  def check_password
    admin = Admin.find(:first, :conditions => ["name=?", params['login']['user_name']])
    unless admin.nil?
      if admin.password == params['login']['password']
        session[:is_admin] = true
        session[:admin_id] = admin.id
        session[:admin_user] = params['login']['user_name']
        log_user_action("admin login: #{session[:admin_user]}")
        redirect_to :controller => 'home'
      else
        log_user_action("failed admin login")
        session[:is_admin] = false
        redirect_to :action => 'login', :retry => 1
      end
    end
  end
  
end
