# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121122150700) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_fetch_date"
    t.text     "signature"
  end

  create_table "accounts_campaigns", :id => false, :force => true do |t|
    t.integer "account_id",  :null => false
    t.integer "campaign_id", :null => false
  end

  add_index "accounts_campaigns", ["account_id", "campaign_id"], :name => "index_accounts_campaigns_on_account_id_and_campaign_id", :unique => true

  create_table "campaigns", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "search_query",    :default => "is:unread"
    t.datetime "last_fetch_date"
    t.string   "label"
    t.boolean  "status",          :default => true,        :null => false
  end

  create_table "histories", :force => true do |t|
    t.integer  "lead_id"
    t.string   "type"
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.integer  "timer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lead_details", :force => true do |t|
    t.integer  "lead_id"
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "note"
  end

  create_table "leads", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "account_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "status",                  :default => "new"
    t.integer  "raiting"
    t.string   "phone"
    t.string   "country"
    t.string   "city"
    t.string   "address"
    t.string   "source"
    t.datetime "last_contacted"
    t.integer  "step",                    :default => 0
    t.boolean  "automatic",               :default => true
    t.integer  "messages_received_count", :default => 0
    t.integer  "messages_sent_count",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "resume"
    t.integer  "bounce",                  :default => 0
    t.string   "stage"
    t.integer  "assigned_to"
  end

  create_table "mail_sequences", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "step"
    t.string   "subject"
    t.text     "body_text"
    t.text     "body_html"
    t.string   "description"
    t.integer  "send_after"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "automatic"
  end

  create_table "messages", :force => true do |t|
    t.integer  "account_id"
    t.integer  "lead_id"
    t.string   "from"
    t.string   "to"
    t.text     "headers"
    t.text     "body"
    t.text     "body_raw"
    t.boolean  "readed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "message_id"
    t.datetime "date"
    t.string   "subject"
    t.boolean  "from_account", :default => false, :null => false
    t.string   "from_raw"
    t.string   "to_raw"
    t.boolean  "countable"
  end

  create_table "scheduled_messages", :force => true do |t|
    t.integer  "account_id"
    t.integer  "lead_id"
    t.string   "to"
    t.string   "cc"
    t.string   "bcc"
    t.string   "subject"
    t.text     "body"
    t.text     "body_html"
    t.datetime "scheduled"
    t.boolean  "sent",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "message_id"
  end

  create_table "text_models", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "will_filter_filters", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.text     "data"
    t.integer  "user_id"
    t.string   "model_class_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "will_filter_filters", ["user_id"], :name => "index_will_filter_filters_on_user_id"

end
