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

ActiveRecord::Schema.define(version: 20150908093025) do

  create_table "course_semester_module_relations", force: :cascade do |t|
    t.integer  "epitech_module_id",           limit: 4, null: false
    t.integer  "course_semester_relation_id", limit: 4, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "course_semester_module_relations", ["epitech_module_id", "course_semester_relation_id"], name: "epitech_module_id_and_course_semester_module_relations", unique: true, using: :btree

  create_table "course_semester_relations", force: :cascade do |t|
    t.integer  "course_id",    limit: 4, null: false
    t.integer  "semester_id",  limit: 4, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "scholar_year", limit: 4, null: false
  end

  add_index "course_semester_relations", ["course_id", "semester_id", "scholar_year"], name: "index_course_semester_relations_on_course_id_and_semester_id", unique: true, using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "degree",      limit: 255
    t.string   "degree_type", limit: 255
    t.integer  "school_id",   limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "name",        limit: 255, default: ""
  end

  add_index "courses", ["degree", "degree_type"], name: "index_courses_on_degree_and_degree_type", unique: true, using: :btree
  add_index "courses", ["name"], name: "index_courses_on_name", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,          default: 0, null: false
    t.integer  "attempts",   limit: 4,          default: 0, null: false
    t.text     "handler",    limit: 4294967295,             null: false
    t.text     "last_error", limit: 4294967295
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "epitech_module_responsable_relations", force: :cascade do |t|
    t.integer "epitech_module_id", limit: 4
    t.integer "responsable_id",    limit: 4
  end

  add_index "epitech_module_responsable_relations", ["epitech_module_id", "responsable_id"], name: "responsable_relations_on_epitech_module_id_and_responsable_id", unique: true, using: :btree

  create_table "epitech_modules", force: :cascade do |t|
    t.string   "name",                  limit: 255
    t.string   "code",                  limit: 255,                   null: false
    t.integer  "flags",                 limit: 4,     default: 0
    t.integer  "credits",               limit: 4,     default: 0
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "semester_id",           limit: 4
    t.boolean  "optional",              limit: 1,     default: false
    t.boolean  "progressive",           limit: 1,     default: false
    t.boolean  "course_mandatory",      limit: 1,     default: false
    t.boolean  "year_mandatory",        limit: 1,     default: false
    t.boolean  "multiple_registration", limit: 1,     default: false
    t.boolean  "hidden_on_resume",      limit: 1,     default: false
    t.boolean  "mandatory",             limit: 1,     default: false
    t.boolean  "security",              limit: 1,     default: false
    t.text     "description",           limit: 65535
  end

  add_index "epitech_modules", ["code"], name: "index_epitech_modules_on_code", unique: true, using: :btree

  create_table "first_year_checkups", force: :cascade do |t|
    t.boolean  "absent",         limit: 1
    t.string   "nature",         limit: 255
    t.integer  "success_chance", limit: 4,                     null: false
    t.text     "comment",        limit: 65535
    t.text     "objectives",     limit: 65535
    t.date     "due_date"
    t.text     "post_it",        limit: 65535
    t.boolean  "as_intership",   limit: 1,     default: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.boolean  "imported",       limit: 1,     default: false
  end

  create_table "grades", force: :cascade do |t|
    t.float    "grade",                                limit: 24,                 null: false
    t.text     "comment",                              limit: 65535
    t.date     "date"
    t.integer  "module_instance_activity_relation_id", limit: 4,                  null: false
    t.integer  "corrector_id",                         limit: 4
    t.string   "data_hash",                            limit: 32,    default: ""
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.integer  "module_instance_student_relation_id",  limit: 4
  end

  add_index "grades", ["corrector_id"], name: "index_grades_on_corrector_id", using: :btree
  add_index "grades", ["date"], name: "index_grades_on_date", using: :btree
  add_index "grades", ["module_instance_activity_relation_id"], name: "index_grades_on_module_instance_activity_relation_id", using: :btree
  add_index "grades", ["module_instance_student_relation_id", "module_instance_activity_relation_id"], name: "module_instance_student_relation_and_module_instance_activity", using: :btree

  create_table "group_user_relations", force: :cascade do |t|
    t.integer "user_id",  limit: 4, null: false
    t.integer "group_id", limit: 4, null: false
  end

  add_index "group_user_relations", ["user_id", "group_id"], name: "index_group_user_relations_on_user_id_and_group_id", unique: true, using: :btree

  create_table "groups", force: :cascade do |t|
    t.string  "title",        limit: 255,             null: false
    t.integer "access_level", limit: 4,   default: 0
  end

  add_index "groups", ["title"], name: "index_groups_on_title", unique: true, using: :btree

  create_table "instance_activity_group_student_relationships", force: :cascade do |t|
    t.integer  "instance_activity_group_id", limit: 4,                 null: false
    t.integer  "student_id",                 limit: 4,                 null: false
    t.boolean  "leader",                     limit: 1, default: false
    t.boolean  "confirmed",                  limit: 1, default: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  add_index "instance_activity_group_student_relationships", ["instance_activity_group_id", "student_id"], name: "student_relationships_on_instance_activity_group_and_student", using: :btree
  add_index "instance_activity_group_student_relationships", ["instance_activity_group_id"], name: "instance_activity_group_id", using: :btree
  add_index "instance_activity_group_student_relationships", ["student_id"], name: "student_id", using: :btree

  create_table "instance_activity_groups", force: :cascade do |t|
    t.integer  "module_instance_activity_relation_id", limit: 4,                null: false
    t.string   "data_hash",                            limit: 255, default: "", null: false
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
  end

  add_index "instance_activity_groups", ["module_instance_activity_relation_id"], name: "instance_activity_groups_on_module_instance_activity_relation_id", using: :btree

  create_table "module_activities", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.string   "activity_title",    limit: 255,   null: false
    t.string   "activity_code",     limit: 255,   null: false
    t.text     "description",       limit: 65535
    t.integer  "epitech_module_id", limit: 4,     null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "module_activities", ["epitech_module_id", "title"], name: "index_module_activities_on_epitech_module_id_and_title", using: :btree

  create_table "module_instance_activity_rdvs", force: :cascade do |t|
    t.integer  "module_instance_activity_id", limit: 4, null: false
    t.integer  "group_id",                    limit: 4, null: false
    t.datetime "datetime",                              null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "module_instance_activity_relations", force: :cascade do |t|
    t.string   "code",               limit: 255,                 null: false
    t.date     "begin"
    t.date     "end"
    t.boolean  "is_grades",          limit: 1,   default: false
    t.integer  "module_activity_id", limit: 4,                   null: false
    t.integer  "module_instance_id", limit: 4,                   null: false
    t.string   "grades_hash",        limit: 32,  default: ""
    t.string   "groups_hash",        limit: 32,  default: ""
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.boolean  "is_project",         limit: 1,   default: false
    t.boolean  "is_registration",    limit: 1,   default: false
    t.float    "min",                limit: 24
    t.float    "max",                limit: 24
  end

  add_index "module_instance_activity_relations", ["code"], name: "index_module_instance_activity_relations_on_code", unique: true, using: :btree
  add_index "module_instance_activity_relations", ["module_activity_id"], name: "index_module_instance_activity_relations_on_module_activity_id", using: :btree
  add_index "module_instance_activity_relations", ["module_instance_id"], name: "index_module_instance_activity_relations_on_module_instance_id", using: :btree

  create_table "module_instance_event_student_relations", force: :cascade do |t|
    t.integer  "event_id",   limit: 4,                 null: false
    t.integer  "student_id", limit: 4,                 null: false
    t.boolean  "present",    limit: 1, default: false
    t.boolean  "absent",     limit: 1, default: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "module_instance_event_student_relations", ["event_id", "student_id"], name: "module_instance_event_student_relations_on_event_id_and_student", unique: true, using: :btree

  create_table "module_instance_events", force: :cascade do |t|
    t.string   "code",        limit: 255,              null: false
    t.integer  "activity_id", limit: 4,                null: false
    t.datetime "datetime",                             null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "data_hash",   limit: 32,  default: ""
  end

  add_index "module_instance_events", ["activity_id"], name: "index_module_instance_events_on_activity_id", using: :btree

  create_table "module_instance_professor_relations", force: :cascade do |t|
    t.integer "module_instance_id", limit: 4
    t.integer "professor_id",       limit: 4
  end

  add_index "module_instance_professor_relations", ["module_instance_id", "professor_id"], name: "responsable_relations_on_epitech_module_id_and_responsable_id", unique: true, using: :btree

  create_table "module_instance_student_relations", force: :cascade do |t|
    t.integer  "module_instance_id", limit: 4,                 null: false
    t.integer  "student_id",         limit: 4,                 null: false
    t.date     "registration_date"
    t.integer  "credits",            limit: 4
    t.integer  "flags",              limit: 4
    t.string   "grade",              limit: 255, default: "-"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.float    "average",            limit: 24,  default: 0.0
  end

  add_index "module_instance_student_relations", ["module_instance_id", "student_id"], name: "instance_student_relations_on_module_instance_id_and_student_id", unique: true, using: :btree

  create_table "module_instances", force: :cascade do |t|
    t.integer  "epitech_module_id", limit: 4,                          null: false
    t.string   "code",              limit: 255,                        null: false
    t.string   "scholar_year",      limit: 255,                        null: false
    t.string   "location",          limit: 255
    t.date     "begin"
    t.date     "end"
    t.date     "end_register"
    t.date     "crawler_stamp",                 default: '0001-01-01'
    t.boolean  "corrupted",         limit: 1,   default: false
    t.string   "activities_hash",   limit: 32,  default: ""
    t.string   "students_hash",     limit: 32,  default: ""
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.float    "min",               limit: 24
    t.float    "max",               limit: 24
  end

  add_index "module_instances", ["epitech_module_id", "code", "scholar_year"], name: "module_instances_on_epitech_module_id_and_code_and_scholar_year", unique: true, using: :btree

  create_table "schools", force: :cascade do |t|
    t.string   "name",        limit: 255, null: false
    t.string   "short_name",  limit: 255, null: false
    t.integer  "nb_year",     limit: 4,   null: false
    t.integer  "nb_semester", limit: 4,   null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "schools", ["name"], name: "index_schools_on_name", unique: true, using: :btree

  create_table "second_year_checkups", force: :cascade do |t|
    t.integer  "success_chance", limit: 4,                 null: false
    t.boolean  "as_hub_project", limit: 1, default: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "imported",       limit: 1, default: false
  end

  create_table "semesters", force: :cascade do |t|
    t.string   "name",               limit: 255, null: false
    t.integer  "number",             limit: 4
    t.integer  "minimal_credits",    limit: 4
    t.integer  "average_credits",    limit: 4
    t.integer  "expected_credits",   limit: 4
    t.integer  "minimal_log_time",   limit: 4
    t.integer  "expected_log_time",  limit: 4
    t.integer  "parent_semester_id", limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "scholar_year",       limit: 4,   null: false
  end

  add_index "semesters", ["name"], name: "index_semesters_on_name", unique: true, using: :btree

  create_table "serialized_exceptions", force: :cascade do |t|
    t.string   "class_name",          limit: 255
    t.string   "exception_class",     limit: 255
    t.text     "exception_message",   limit: 4294967295
    t.text     "serialized_instance", limit: 4294967295
    t.text     "serialized_stack",    limit: 4294967295
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "student_checkup_relations", force: :cascade do |t|
    t.integer  "student_id",   limit: 4,   null: false
    t.integer  "user_id",      limit: 4,   null: false
    t.integer  "checkup_id",   limit: 4,   null: false
    t.string   "checkup_type", limit: 255, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "student_checkup_relations", ["student_id", "checkup_id", "user_id", "checkup_type"], name: "checkup_relations_on_student_id_and_checkup_id_and_checkup_type", unique: true, using: :btree

  create_table "student_user_relations", force: :cascade do |t|
    t.integer  "user_id",    limit: 4, null: false
    t.integer  "student_id", limit: 4, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "student_user_relations", ["user_id", "student_id"], name: "index_student_user_relations_on_user_id_and_student_id", unique: true, using: :btree

  create_table "students", force: :cascade do |t|
    t.string   "login",                       limit: 255,                               null: false
    t.string   "name",                        limit: 255
    t.string   "picture",                     limit: 255
    t.string   "location",                    limit: 255
    t.integer  "promo",                       limit: 4
    t.integer  "credits",                     limit: 4
    t.integer  "scholar_year",                limit: 4
    t.float    "netsoul_value",               limit: 24,         default: -1.0
    t.integer  "success_chance",              limit: 4,          default: 0
    t.date     "last_checkup_date",                              default: '0001-01-01'
    t.date     "crawler_stamp",                                  default: '0001-01-01'
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.float    "gpa_bachelor",                limit: 24
    t.float    "gpa_master",                  limit: 24
    t.text     "close",                       limit: 65535
    t.date     "close_date"
    t.integer  "promo_id",                    limit: 4
    t.integer  "school_id",                   limit: 4
    t.float    "grades_evolution",            limit: 24
    t.float    "grades_average_start",        limit: 24
    t.text     "grades_data",                 limit: 65535
    t.float    "grades_average_end",          limit: 24
    t.integer  "course_semester_relation_id", limit: 4
    t.text     "logs",                        limit: 4294967295
  end

  add_index "students", ["course_semester_relation_id"], name: "index_students_on_course_semester_relation_id", using: :btree
  add_index "students", ["login"], name: "index_students_on_login", unique: true, using: :btree

  create_table "third_year_checkups", force: :cascade do |t|
    t.integer  "success_chance", limit: 4,                 null: false
    t.boolean  "as_part_time",   limit: 1, default: false
    t.boolean  "as_internship",  limit: 1, default: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "imported",       limit: 1, default: false
  end

  create_table "ticket_assignations", force: :cascade do |t|
    t.integer  "ticket_id",            limit: 4,                 null: false
    t.integer  "user_id",              limit: 4,                 null: false
    t.integer  "last_read_message_id", limit: 4, default: 0
    t.boolean  "ignored",              limit: 1, default: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.datetime "last_visit"
  end

  add_index "ticket_assignations", ["user_id", "ticket_id"], name: "index_ticket_assignations_on_user_id_and_ticket_id", unique: true, using: :btree
  add_index "ticket_assignations", ["user_id"], name: "index_ticket_assignations_on_user_id", using: :btree

  create_table "ticket_messages", force: :cascade do |t|
    t.integer  "ticket_id",    limit: 4,                    null: false
    t.integer  "user_id",      limit: 4,                    null: false
    t.text     "message",      limit: 65535,                null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "modification", limit: 255,   default: "{}"
  end

  add_index "ticket_messages", ["ticket_id"], name: "index_ticket_messages_on_ticket_id", using: :btree
  add_index "ticket_messages", ["user_id"], name: "index_ticket_messages_on_user_id", using: :btree

  create_table "tickets", force: :cascade do |t|
    t.integer  "student_id",      limit: 4,                 null: false
    t.integer  "user_id",         limit: 4,                 null: false
    t.integer  "last_message_id", limit: 4,     default: 0, null: false
    t.string   "title",           limit: 255,               null: false
    t.integer  "category",        limit: 4,                 null: false
    t.integer  "status",          limit: 4,     default: 0, null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.text     "description",     limit: 65535,             null: false
  end

  add_index "tickets", ["category"], name: "index_tickets_on_category", using: :btree
  add_index "tickets", ["status"], name: "index_tickets_on_status", using: :btree
  add_index "tickets", ["student_id"], name: "index_tickets_on_student_id", using: :btree
  add_index "tickets", ["user_id"], name: "index_tickets_on_user_id", using: :btree

  create_table "user_manager_relations", force: :cascade do |t|
    t.integer  "manager_id", limit: 4, null: false
    t.integer  "user_id",    limit: 4, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "user_manager_relations", ["manager_id", "user_id"], name: "index_user_manager_relations_on_manager_id_and_user_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "login",               limit: 255, default: "",           null: false
    t.string   "encrypted_password",  limit: 255, default: "",           null: false
    t.date     "last_intra_check",                default: '0001-01-01', null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       limit: 4,   default: 0,            null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",  limit: 255
    t.string   "last_sign_in_ip",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree

end
