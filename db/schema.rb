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

ActiveRecord::Schema.define(:version => 20130416143223) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.boolean  "public",      :default => true
    t.boolean  "published"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "permalink"
    t.integer  "category_id"
  end

  add_index "articles", ["permalink"], :name => "index_articles_on_permalink"

  create_table "attendants", :force => true do |t|
    t.integer  "user_id"
    t.string   "role"
    t.integer  "event_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "blog_posts", :force => true do |t|
    t.integer  "blog_id"
    t.text     "content"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "public",     :default => false
  end

  add_index "blog_posts", ["blog_id", "created_at"], :name => "index_blog_posts_on_blog_id_and_created_at"

  create_table "blogs", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "blogs", ["user_id"], :name => "index_blogs_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "weight"
  end

  create_table "comments", :force => true do |t|
    t.integer  "commenter_id"
    t.integer  "commentable_id"
    t.string   "commentable_type", :default => "",   :null => false
    t.text     "content"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "public",           :default => true
    t.string   "commenter_name"
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["commenter_id"], :name => "index_comments_on_commenter_id"

  create_table "competitions", :force => true do |t|
    t.string   "name"
    t.integer  "event_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "order_index"
  end

  create_table "conversations", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.string   "city"
    t.string   "country"
    t.string   "state"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.boolean  "ifpa_sanctioned"
  end

  create_table "feeds", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "store_name"
    t.boolean  "hidden",      :default => false
    t.integer  "user_id"
    t.string   "permalink"
    t.text     "description"
    t.boolean  "public"
  end

  create_table "likes", :force => true do |t|
    t.integer  "liker_id"
    t.integer  "liked_item_id"
    t.string   "liked_item_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "likes", ["liked_item_id", "liked_item_type"], :name => "index_likes_on_liked_item_id_and_liked_item_type"
  add_index "likes", ["liker_id"], :name => "index_likes_on_liker_id"

  create_table "listeners", :force => true do |t|
    t.integer  "user_id"
    t.integer  "listened_to_id"
    t.string   "listened_to_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "messages", :force => true do |t|
    t.text     "content"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "read"
    t.integer  "conversation_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "messages", ["conversation_id"], :name => "index_messages_on_conversation_id"
  add_index "messages", ["recipient_id"], :name => "index_messages_on_recipient_id"
  add_index "messages", ["sender_id"], :name => "index_messages_on_sender_id"

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sender_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "action_type"
    t.integer  "action_id"
    t.boolean  "public"
    t.boolean  "read",        :default => false
  end

  add_index "notifications", ["read"], :name => "index_notifications_on_read"
  add_index "notifications", ["user_id"], :name => "index_notifications_on_user_id"

  create_table "pages", :force => true do |t|
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "posts", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "public",     :default => true
    t.boolean  "sticky",     :default => false
    t.integer  "feed_id"
  end

  add_index "posts", ["created_at"], :name => "index_posts_on_created_at"
  add_index "posts", ["sticky"], :name => "index_posts_on_sticky"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "results", :force => true do |t|
    t.integer  "competition_id"
    t.integer  "position"
    t.string   "description"
    t.integer  "video_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "results_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "result_id"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "remember_token"
    t.string   "password_digest"
    t.boolean  "admin"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "gravatar_suffix"
    t.string   "nickname"
    t.string   "reset_code"
    t.string   "country"
    t.string   "city"
    t.string   "modified_user"
    t.boolean  "author",           :default => false
    t.datetime "birthday"
    t.datetime "started_playing"
    t.boolean  "bap",              :default => false
    t.string   "bap_name"
    t.datetime "bap_induction"
    t.string   "motto"
    t.text     "hobbies"
    t.integer  "privacy_settings", :default => 0
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "last_visit"
    t.string   "about_title"
    t.text     "about_content"
    t.boolean  "registered",       :default => true
    t.string   "website"
    t.datetime "last_online"
  end

  add_index "users", ["country"], :name => "index_users_on_country"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "users_videos", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "video_id"
  end

  create_table "videos", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "vendor"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "uid"
    t.string   "url"
    t.boolean  "public",       :default => true
    t.string   "location"
    t.string   "maker"
    t.text     "players"
    t.boolean  "for_feedback", :default => false
    t.integer  "feed_id"
  end

  add_index "videos", ["uid"], :name => "index_videos_on_uid", :unique => true
  add_index "videos", ["user_id", "created_at"], :name => "index_videos_on_user_id_and_created_at"

end
