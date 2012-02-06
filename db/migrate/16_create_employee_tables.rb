class CreateEmployeeTables < ActiveRecord::Migration
  
  def self.up
    create_table :employees, :primary_key => 'id' do |t|
      t.column :id, :integer, :null => false
      t.column :name, :string, :null => true
      #t.index :name, :unique => true, :name => 'unique_name'
      t.timestamps
    end

    create_table :employee_hours, :primary_key => 'id' do |t|
      t.column :id, :integer, :null => false
      t.column :employee_id, :integer, :null => false
      t.column :inout, :string, :null => false, :limit => 8
      t.timestamps
    end

  end

  def self.down
    drop_table :employees
    drop_table :employee_hours
  end
  
end
