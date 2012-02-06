# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20) do

  create_table "admins", :force => true do |t|
    t.string "name",     :limit => 64, :default => "", :null => false
    t.string "password", :limit => 64, :default => "", :null => false
  end

  create_table "cc_records", :force => true do |t|
    t.integer  "user_id"
    t.string   "cc",         :limit => 512
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cleaning_categories", :force => true do |t|
    t.string "name", :limit => 64
  end

  create_table "cleaning_category_items", :force => true do |t|
    t.integer "cleaning_category_id",                :null => false
    t.string  "name",                 :limit => 128
    t.float   "price"
    t.float   "delivery_price"
  end

  create_table "completed_pickups", :force => true do |t|
    t.integer  "pickup_id",   :null => false
    t.datetime "pickup_date", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deleted_orders", :force => true do |t|
    t.text     "html",                      :null => false
    t.text     "reason",     :limit => 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin_id"
  end

  create_table "deliveries", :force => true do |t|
    t.integer  "pickup_id"
    t.datetime "delivery_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_hours", :force => true do |t|
    t.integer  "employee_id",              :null => false
    t.string   "inout",       :limit => 8, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "no_perc_points", :force => true do |t|
    t.integer "user_id",                                :null => false
    t.integer "points",                 :default => 0
    t.string  "reason",   :limit => 64, :default => ""
    t.integer "order_id"
  end

  create_table "order_discounts", :force => true do |t|
    t.integer  "order_id"
    t.float    "amount"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "order_items", :force => true do |t|
    t.integer  "order_id",                                   :null => false
    t.integer  "cleaning_category_item_id",                  :null => false
    t.integer  "quantity",                                   :null => false
    t.string   "description"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.float    "unit_price"
    t.float    "discount",                  :default => 1.0
    t.integer  "admin_id"
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id",                                         :null => false
    t.boolean  "paid",                         :default => false
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "order_receipt", :limit => 256
    t.string   "date_needed",   :limit => 128
    t.integer  "admin_id"
  end

  create_table "payments", :force => true do |t|
    t.integer  "order_id",                       :null => false
    t.float    "amount",                         :null => false
    t.float    "tax",                            :null => false
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "payment_method",  :limit => 2,   :null => false
    t.string   "check_num",       :limit => 16
    t.string   "payment_receipt", :limit => 256
    t.datetime "payment_date"
    t.integer  "admin_id"
  end

  create_table "pickups", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.datetime "pickup_date", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :default => "", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.string "name"
    t.string "value"
  end

  create_table "user_actions", :force => true do |t|
    t.integer  "admin_id"
    t.string   "description", :limit => 512
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string  "first_name",        :limit => 128,                    :null => false
    t.string  "last_name",         :limit => 128,                    :null => false
    t.string  "email_address",     :limit => 128
    t.string  "password",          :limit => 32
    t.string  "address1",          :limit => 256,                    :null => false
    t.string  "address2",          :limit => 256
    t.string  "city",              :limit => 128,                    :null => false
    t.string  "state",             :limit => 32,                     :null => false
    t.string  "zip",               :limit => 16,                     :null => false
    t.string  "phone",             :limit => 32,                     :null => false
    t.string  "alternate_phone",   :limit => 32
    t.string  "birthday",          :limit => 32
    t.string  "referred_by",       :limit => 128
    t.string  "shirt_laundry",     :limit => 256
    t.string  "dry_cleaning",      :limit => 256
    t.string  "laundry",           :limit => 256
    t.boolean "delivery_customer",                :default => true
    t.string  "howd_you_hear",     :limit => 256
    t.string  "uuid",              :limit => 64,  :default => ""
    t.boolean "verified",                         :default => false
  end

  create_table "users_backup", :force => true do |t|
    t.string  "first_name",        :limit => 128,                    :null => false
    t.string  "last_name",         :limit => 128,                    :null => false
    t.string  "email_address",     :limit => 128
    t.string  "password",          :limit => 32
    t.string  "address1",          :limit => 256,                    :null => false
    t.string  "address2",          :limit => 256
    t.string  "city",              :limit => 128,                    :null => false
    t.string  "state",             :limit => 32,                     :null => false
    t.string  "zip",               :limit => 16,                     :null => false
    t.string  "phone",             :limit => 32,                     :null => false
    t.string  "alternate_phone",   :limit => 32
    t.string  "birthday",          :limit => 32
    t.string  "referred_by",       :limit => 128
    t.string  "shirt_laundry",     :limit => 256
    t.string  "dry_cleaning",      :limit => 256
    t.string  "laundry",           :limit => 256
    t.boolean "delivery_customer",                :default => true
    t.string  "howd_you_hear",     :limit => 256
    t.string  "uuid",              :limit => 64,  :default => ""
    t.boolean "verified",                         :default => false
  end

end
