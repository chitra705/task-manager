# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_01_07_053934) do
  create_table "access_roles", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.integer "name"
    t.string "emp_type"
    t.bigint "emp_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["emp_type", "emp_id"], name: "index_access_roles_on_emp"
  end

  create_table "active_storage_attachments", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "dev_teams", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "team_list_type"
    t.bigint "team_list_id"
    t.string "emp_type"
    t.bigint "emp_id"
    t.string "project_task_type"
    t.bigint "project_task_id"
    t.datetime "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["emp_type", "emp_id"], name: "index_dev_teams_on_emp"
    t.index ["project_task_type", "project_task_id"], name: "index_dev_teams_on_project_task"
    t.index ["team_list_type", "team_list_id"], name: "index_dev_teams_on_team_list"
  end

  create_table "emp_details", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.decimal "slary_per_day", precision: 10
    t.decimal "basic_salary", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "emp_id"
    t.index ["emp_id"], name: "index_emp_details_on_emp_id"
  end

  create_table "emps", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "name"
    t.date "dob"
    t.string "mobile"
    t.string "email"
    t.text "address"
    t.string "location"
    t.string "blood_group"
    t.integer "status"
    t.string "access_role_type"
    t.bigint "access_role_id"
    t.string "user_type"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "team_type"
    t.date "joining_date"
    t.string "designation"
    t.index ["access_role_type", "access_role_id"], name: "index_emps_on_access_role"
    t.index ["user_type", "user_id"], name: "index_emps_on_user"
  end

  create_table "leads", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "emp_id"
    t.integer "status"
    t.string "category"
    t.string "category_name"
    t.string "business_name"
    t.text "address"
    t.string "city"
    t.string "state"
    t.integer "postal_code"
    t.string "country"
    t.bigint "phone"
    t.string "email"
    t.string "website"
    t.string "latitude"
    t.string "longitude"
    t.string "map_link"
    t.text "details"
    t.string "mobile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["emp_id"], name: "index_leads_on_emp_id"
    t.index ["user_id"], name: "index_leads_on_user_id"
  end

  create_table "leave_requests", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.datetime "leave_date"
    t.string "leave_reason"
    t.bigint "user_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_leave_requests_on_user_id"
  end

  create_table "marketting_teams", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "team_list_type"
    t.bigint "team_list_id"
    t.string "emp_type"
    t.bigint "emp_id"
    t.string "project_task_type"
    t.bigint "project_task_id"
    t.datetime "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["emp_type", "emp_id"], name: "index_marketting_teams_on_emp"
    t.index ["project_task_type", "project_task_id"], name: "index_marketting_teams_on_project_task"
    t.index ["team_list_type", "team_list_id"], name: "index_marketting_teams_on_team_list"
  end

  create_table "payment_details", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "total_salary"
    t.float "given_amount"
    t.bigint "user_id"
    t.bigint "emp_id"
    t.index ["emp_id"], name: "index_payment_details_on_emp_id"
    t.index ["user_id"], name: "index_payment_details_on_user_id"
  end

  create_table "payslip_total_values", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.float "total_earnings"
    t.float "total_deductions"
    t.float "net_pay"
    t.bigint "user_id"
    t.string "sal_payslip_type"
    t.bigint "sal_payslip_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sal_payslip_type", "sal_payslip_id"], name: "index_payslip_total_values_on_sal_payslip"
    t.index ["user_id"], name: "index_payslip_total_values_on_user_id"
  end

  create_table "payslip_values", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "earnings"
    t.float "earning_amount"
    t.string "deductions"
    t.float "deduction_amount"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sal_payslip_type"
    t.bigint "sal_payslip_id"
    t.index ["sal_payslip_type", "sal_payslip_id"], name: "index_payslip_values_on_sal_payslip"
    t.index ["user_id"], name: "index_payslip_values_on_user_id"
  end

  create_table "payslips", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "emp_id"
    t.bigint "emp_detail_id"
    t.decimal "incentive_pay", precision: 10
    t.decimal "provident_fund", precision: 10
    t.decimal "profesional_tax", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["emp_detail_id"], name: "index_payslips_on_emp_detail_id"
    t.index ["emp_id"], name: "index_payslips_on_emp_id"
    t.index ["user_id"], name: "index_payslips_on_user_id"
  end

  create_table "project_tasks", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "status"
    t.string "assigned_to_type"
    t.bigint "assigned_to_id"
    t.string "created_by_type"
    t.bigint "created_by_id"
    t.float "duration"
    t.integer "categories"
    t.string "team_type"
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "due_start_date"
    t.date "due_end_date"
    t.index ["assigned_to_type", "assigned_to_id"], name: "index_project_tasks_on_assigned_to"
    t.index ["created_by_type", "created_by_id"], name: "index_project_tasks_on_created_by"
    t.index ["team_type", "team_id"], name: "index_project_tasks_on_team"
  end

  create_table "sal_payslips", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "pay_period"
    t.integer "worked_days"
    t.string "employee_name"
    t.string "designation"
    t.string "department"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sal_payslips_on_user_id"
  end

  create_table "task_logs", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.integer "status"
    t.string "project_task_type"
    t.bigint "project_task_id"
    t.bigint "user_id"
    t.time "pause"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time "start_time"
    t.time "elapsed_time"
    t.string "active"
    t.index ["project_task_type", "project_task_id"], name: "index_task_logs_on_project_task"
    t.index ["user_id"], name: "index_task_logs_on_user_id"
  end

  create_table "team_lists", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.integer "name"
    t.string "team_type"
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_type", "team_id"], name: "index_team_lists_on_team"
  end

  create_table "time_values", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.time "time"
    t.integer "time_value", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_break_logs", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.datetime "break_in"
    t.datetime "break_out"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_break_logs_on_user_id"
  end

  create_table "user_check_logs", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.datetime "check_in"
    t.datetime "check_out"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_check_logs_on_user_id"
  end

  create_table "user_logs", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "user_type"
    t.bigint "user_id"
    t.datetime "check_in"
    t.datetime "check_out"
    t.date "log_date"
    t.datetime "login_time"
    t.datetime "logout_time"
    t.string "session_ip_address"
    t.datetime "inactive_time"
    t.string "location"
    t.datetime "break_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_active_time"
    t.integer "active_time"
    t.index ["user_type", "user_id"], name: "index_user_logs_on_user"
  end

  create_table "users", charset: "utf8mb3", collation: "utf8mb3_general_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "mobile", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "name"
    t.integer "role", default: 3
    t.string "otp"
    t.datetime "otp_sent_at"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "dob"
    t.text "address"
    t.string "location"
    t.string "blood_group"
    t.string "emp_type"
    t.bigint "emp_id"
    t.boolean "approved", default: false
    t.integer "team_type"
    t.date "joining_date"
    t.string "designation"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["emp_type", "emp_id"], name: "index_users_on_emp"
    t.index ["mobile"], name: "index_users_on_mobile", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
