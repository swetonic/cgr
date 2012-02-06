

class AutocompleteController < ApplicationController 
  
  protect_from_forgery :except => [:last_name, :phone, :email]

  def phone
    users = User.find(:all, 
        :conditions => "phone like '%%#{params['user']['phone']}%%'",
        :limit => 10)
    
    unless users.empty?
      html = '<ul>'
      users.each do |user|
        html += "<li>#{user.phone } - #{user.first_name} #{user.last_name} (#{user.id})</li>"
      end
      html += '</ul>'
      render :text => html
      return
    end
    return :text => ''
  end

  def email
    users = User.find(:all, 
        :conditions => "email_address like '%%#{params['user']['email_address']}%%'")
    
    unless users.empty?
      html = '<ul>'
      users.each do |user|
        html += "<li>#{user.email_address }, #{user.last_name} (#{user.id})</li>"
      end
      html += '</ul>'
      render :text => html
      return
    end
    return :text => ''
  end
  
  def last_name
    users = User.find(:all, 
        :conditions => "last_name like '#{params['user']['last_name']}%%'")
    
    unless users.empty?
      html = '<ul>'
      users.each do |user|
        html += "<li>#{user.first_name} #{user.last_name} (#{user.id})</li>"
      end
      html += '</ul>'
      render :text => html
      return
    end
    
    render :text => ''
    
  end
  
end


