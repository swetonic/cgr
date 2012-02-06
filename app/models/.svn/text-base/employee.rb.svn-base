
class Employee < ActiveRecord::Base

  def self.get_all
    employees = {}
    find(:all).collect { |r| employees[r.name] = r.id }
    employees
  end


  def self.add(name)
    new_employee = create(:name => name)
    new_employee.save!
    new_employee.id
  end

end
