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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180401205610) do

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token",    limit: 255
    t.datetime "expires_at"
    t.integer  "user_setting_id", limit: 4
    t.boolean  "active",                      default: true
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "api_keys", ["access_token"], name: "index_api_keys_on_access_token", using: :btree
  add_index "api_keys", ["user_setting_id"], name: "index_api_keys_on_user_setting_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 16777215
    t.integer  "user_id",     limit: 4
    t.integer  "parent_id",   limit: 4
    t.integer  "lft",         limit: 4,                    null: false
    t.integer  "rgt",         limit: 4,                    null: false
    t.integer  "depth",       limit: 4,        default: 0, null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "categories", ["lft"], name: "index_categories_on_lft", using: :btree
  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  add_index "categories", ["rgt"], name: "index_categories_on_rgt", using: :btree

  create_table "category_pictures", force: :cascade do |t|
    t.integer  "category_id", limit: 4
    t.integer  "picture_id",  limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "category_pictures", ["category_id", "picture_id"], name: "index_category_pictures_on_category_id_and_picture_id", using: :btree

  create_table "locales", force: :cascade do |t|
    t.string   "locale",     limit: 255
    t.string   "name",       limit: 255
    t.boolean  "visible",                default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locales", ["locale"], name: "index_locales_on_locale", using: :btree
  add_index "locales", ["name"], name: "index_locales_on_name", using: :btree

  create_table "look_pictures", force: :cascade do |t|
    t.integer "look_id",         limit: 4
    t.integer "picture_id",      limit: 4
    t.text    "position_params", limit: 65535
  end

  add_index "look_pictures", ["look_id", "picture_id"], name: "index_look_pictures_on_look_id_and_picture_id", using: :btree

  create_table "looks", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "deleted_at"
    t.integer  "picture_id",  limit: 4
    t.integer  "user_id",     limit: 4
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "title",                 limit: 255
    t.text     "description",           limit: 16777215
    t.integer  "user_id",               limit: 4
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "image",                 limit: 255
    t.datetime "deleted_at"
    t.text     "transformation_params", limit: 65535
    t.string   "link",                  limit: 255
  end

  create_table "user_looks", force: :cascade do |t|
    t.integer  "look_id",     limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "is_approved",           default: false
  end

  add_index "user_looks", ["look_id", "user_id"], name: "index_user_looks_on_look_id_and_user_id_and_is_owner", unique: true, using: :btree

  create_table "user_settings", force: :cascade do |t|
    t.string  "time_zone",               limit: 255
    t.integer "locale_id",               limit: 4
    t.integer "user_id",                 limit: 4
    t.integer "look_screen_category_id", limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.datetime "deleted_at"
    t.string   "name",                   limit: 255
    t.date     "birth_date"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
