class CreateCcRecords < ActiveRecord::Migration
  
  def self.up
    create_table :cc_records do |t|
      t.integer :id
      t.integer :user_id
      t.string :cc, :limit => 512
      t.timestamps
    end
  end

  def self.down
    drop_table :cc_records
  end
end

