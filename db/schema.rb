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

ActiveRecord::Schema.define(:version => 20100218194929) do

  create_table "releases", :force => true do |t|
    t.datetime "finished_at"
    t.datetime "created_at"
    t.integer  "finished_by"
  end

  create_table "stories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "due_on"
    t.date     "soft_release_on"
    t.integer  "release_id"
    t.integer  "position"
  end

  create_table "tasks", :force => true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "started_on"
    t.datetime "completed_on"
    t.integer  "author_id"
    t.integer  "assigned_id"
    t.string   "state",         :limit => 30
    t.integer  "verified_by"
    t.string   "category"
    t.integer  "position"
    t.integer  "release_id"
    t.string   "updated_field"
    t.integer  "story_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "developer",         :default => false
  end

end
