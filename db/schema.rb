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

ActiveRecord::Schema.define(:version => 20120929211857) do

  create_table "recipe_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.integer  "position"
  end

  create_table "recipe_selections", :force => true do |t|
    t.integer  "recipe_id"
    t.integer  "soloist_script_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipes", :force => true do |t|
    t.string   "name"
    t.integer  "recipe_group_id"
    t.integer  "row_order_position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "checked_by_default"
  end

  create_table "soloist_scripts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid"
  end

end
