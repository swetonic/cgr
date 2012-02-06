
require 'date'

class EmployeeHour < ActiveRecord::Base

  belongs_to :employee



  def self.employees_in_db
    records = find(:all, :group => 'employee_id')
    records.collect { |e| e.employee }
  end

  def self.hours(id)
    return_info = [] #array of strings

    first_punchin = find(:first, :order => 'created_at asc', :conditions => "employee_id=#{id}")
    last_punchin = find(:first, :order => 'created_at desc', :conditions => "employee_id=#{id}")

    start_date = first_punchin.created_at.to_datetime
    if start_date.cwday != 1
      start_date = start_date - (start_date.cwday - 1)
    end

    #need 0 hours, 0 minutes for querying the db
    start_date = DateTime.parse(sprintf("%d-%02d-%02d", start_date.year,
                                        start_date.month, start_date.day))

    cur_date = start_date
    end_date = last_punchin.created_at.to_datetime + 1  #go one day further

    #need 0 hours, 0 minutes for querying the db
    end_date = DateTime.parse(sprintf("%d-%02d-%02d", end_date.year,
                                        end_date.month, end_date.day))

    while cur_date < end_date
      entry_hash = {}

      #query for hours in this date range
      this_end = cur_date + 7
      entry_hash[:week_start] = cur_date
      entry_hash[:week_end] = (this_end - 1) #for display purposes
      entry_hash[:punch_ins] = []
      entry_hash[:punch_outs] = []

      created_condition = "(created_at > '#{sql_date_format(cur_date)}' and created_at < '#{sql_date_format(this_end)}')"
      additional_condition = " and employee_id=#{id} and `inout`='in'"
      
      in_hours = find(:all, :conditions => created_condition + additional_condition)

      additional_condition = " and employee_id=#{id} and `inout`='out'"
      out_hours = find(:all, :conditions => created_condition + additional_condition)

      total_seconds = 0
      entry_hash[:punches] = []
      if in_hours.length == out_hours.length

        in_hours.each_index do |index|
          entry_hash[:punches] << {:in => in_hours[index], :out => out_hours[index]}

          t1 = Time.mktime(in_hours[index].created_at.utc.year, in_hours[index].created_at.utc.month,
                           in_hours[index].created_at.utc.day, in_hours[index].created_at.utc.hour,
                           in_hours[index].created_at.utc.min,
                           in_hours[index].created_at.utc.sec)
          t2 = Time.mktime(out_hours[index].created_at.utc.year, out_hours[index].created_at.utc.month,
                           out_hours[index].created_at.utc.day, out_hours[index].created_at.utc.hour,
                           out_hours[index].created_at.utc.min,
                           out_hours[index].created_at.utc.sec)

          secs = t2.to_i - t1.to_i
          total_seconds = total_seconds + secs
        end
      else
        #there aren't the same number of punch ins and punch outs
        in_hours.each_index do |index|
          punch_in = in_hours[index]
          
          punch_out = did_punch_out(out_hours,
                  in_hours[index].created_at.month,
                  in_hours[index].created_at.day)

          if punch_out.nil?
            punch_out_time = DateTime.parse(sprintf("%d-%02d-%02d 18:00",
                                   punch_in.created_at.utc.year,
                                   punch_in.created_at.utc.month,
                                   punch_in.created_at.utc.day))
            punch_out = EmployeeHour.new(:created_at => punch_out_time)
          else
            puts 'yo'
          end

          entry_hash[:punches] << {:in => punch_in, :out => punch_out}
          t1 = Time.mktime(punch_in.created_at.utc.year, punch_in.created_at.utc.month,
                           punch_in.created_at.utc.day, punch_in.created_at.utc.hour,
                           punch_in.created_at.utc.min,
                           punch_in.created_at.utc.sec)
          t2 = Time.mktime(punch_out.created_at.utc.year, punch_out.created_at.utc.month,
                           punch_out.created_at.utc.day, punch_out.created_at.utc.hour,
                           punch_out.created_at.utc.min,
                           punch_out.created_at.utc.sec)

          secs = t2.to_i - t1.to_i
          total_seconds = total_seconds + secs
        end
      end

      entry_hash[:total_seconds] = total_seconds
      return_info << entry_hash
      cur_date = cur_date + 7      
    end


    return_info
  end


  def self.did_punch_out(out_hours, month, day)
    punch = nil
    out_hours.each do |punch_out|
      if punch_out.created_at.month == month &&
              punch_out.created_at.day == day
        punch = punch_out
        break
      end
    end
    punch
  end

  def ddf
    created_at.strftime("%a %b %d, %Y %I:%M%p")
  end

  def report_time_format
    created_at.utc.strftime("%I:%M%p")
  end

  def report_date_format
    created_at.utc.strftime("%a %b %d, %Y")
  end

  def self.sql_date_format(date_time)
    sprintf("#{date_time.year}-%02d-%02d", date_time.month, date_time.day)
  end

  def self.has_punched_in_today(employee_id)
    today = DateTime.now
    tomorrow = today + 1

    created_condition = "(created_at >= '#{sql_date_format(today)}' and created_at < '#{sql_date_format(tomorrow)}')"
    emp_hour = EmployeeHour.find(:first,
                                 :conditions => "employee_id=#{employee_id} and #{created_condition}")
    !emp_hour.nil?
  end
  
  def self.can_punch_in
    #just let everyone punch in
    all_employees = Employee.get_all
    can_punch_in = []
    all_employees.each do |emp|
      if !has_punched_in_today(emp[1])
        can_punch_in << emp        
      end
    end
    can_punch_in
    
#    already_in = punched_in
#    already_out = punched_out
#
#    to_delete = []
#    #if they've punched in AND punched out, then they can punch in again
#    already_in.each do |name,params|
#      out_count = 0
#      count = params[:count]
#      if already_out.key?(name)
#        out_count = already_out[name][:count]
#      end
#      count = count - out_count
#      if count == 0
#        to_delete << name
#      end
#    end
#
#    to_delete.each { |name| already_in.delete(name) }
#    rej = all_employees.reject { |key,val| already_in.key?(key) }
#    rej
  end

  def self.can_punch_out
    already_in = punched_in
    already_out = punched_out

    can_punch_out = {}
    #if they've punched in AND punched out, then they can punch in again
    already_in.each do |name,params|
      out_count = 0
      count = params[:count]
      if already_out.key?(name)
        out_count = already_out[name][:count]
      end
      count = count - out_count
      if count == 1
        can_punch_out[name] = already_in[name][:id]
      end
    end
    
    can_punch_out

  end

  
  def self.punched_in
    punch_status('in')
  end

  def self.punched_out
    punch_status('out')
  end

  
  def self.punch_status(status)
    now = DateTime.now
    tomorrow = now + 1

    cond = sprintf("(created_at > '#{now.year}-%02d-%02d' and created_at < '#{tomorrow.year}-%02d-%02d') and `inout`='#{status}'",
        now.month, now.day, tomorrow.month, tomorrow.day)

    already_in = {}
    records = find(:all, :conditions => cond)
    records.each do |r|
      count = 0
      if already_in.key?(r.employee.name)
        count = already_in[r.employee.name][:count]
      end
      count = count + 1
      already_in[r.employee.name] = { :count => count, :id => r.employee.id }
    end

    already_in
  end

  
  def self.punch_in(employee_id)
    punch(employee_id, 'in')
  end

  def self.punch_out(employee_id)
    punch(employee_id, 'out')
  end

  def self.punch(employee_id, inorout)
    employee = Employee.find(employee_id)
    unless employee.nil?
      new_record = create(:employee_id => employee_id, :inout => inorout)
      new_record.save!
    else
      raise "Unknown employee: id = #{employee_id}"
    end
  end

  def self.total_time_seconds(punch_in, punch_out)
    t1 = Time.mktime(punch_in.year, punch_in.month,
                     punch_in.day, punch_in.hour,
                     punch_in.min,
                     punch_in.sec)
    t2 = Time.mktime(punch_out.year, punch_out.month,
                     punch_out.day, punch_out.hour,
                     punch_out.min,
                     punch_out.sec)

    (t2.to_i - t1.to_i)
  end

  

end


