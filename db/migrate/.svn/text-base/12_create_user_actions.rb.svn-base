class CreateUserActions < ActiveRecord::Migration
  
  def self.up
    create_table :user_actions do |t|
      t.integer :id
      t.integer :admin_id
      t.string :description, :limit => 512
      t.timestamps
    end
  end

  def self.down
    drop_table :user_actions
  end
end

