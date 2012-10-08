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

ActiveRecord::Schema.define(:version => 20121008164933) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "campaign_id"
    t.string   "label"
    t.datetime "last_fetch_date"
  end

  create_table "campaigns", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
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

end
