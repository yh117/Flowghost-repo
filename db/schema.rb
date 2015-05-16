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

ActiveRecord::Schema.define(version: 20141224004958) do

  create_table "assignments", force: true do |t|
    t.string   "name"
    t.integer  "course_id"
    t.integer  "points_possible"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "points"
    t.string   "tagnames"
  end

  create_table "courses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "csvmngrs", force: true do |t|
    t.string   "instructor"
    t.string   "email"
    t.integer  "courseid"
    t.string   "filename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grades", force: true do |t|
    t.integer  "student_id"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assignment_id"
  end

  create_table "instructor_users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_emails", force: true do |t|
    t.string   "email"
    t.integer  "course_id"
    t.string   "random_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_id"
  end

  create_table "students", force: true do |t|
    t.string   "email"
    t.integer  "course_id"
    t.string   "random_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_user_id"
  end

  create_table "tag_assignments", force: true do |t|
    t.integer  "assignment_id"
    t.integer  "tag_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "assignmentnames"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "identifiable_id"
    t.string   "identifiable_type"
  end

end
