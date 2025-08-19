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

ActiveRecord::Schema[7.0].define(version: 2025_07_31_123550) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_admin_comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.uuid "resource_id"
    t.string "author_type"
    t.uuid "author_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "middle_name"
    t.string "role", default: "admin", null: false
    t.string "username"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_admin_users_on_role"
  end

  create_table "batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "batch_title", null: false
    t.uuid "program_id"
    t.datetime "starting_date", precision: nil, null: false
    t.datetime "ending_date", precision: nil, null: false
    t.integer "total_number_of_students"
    t.string "created_by"
    t.string "last_updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["program_id"], name: "index_batches_on_program_id"
  end

  create_table "course_registrations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "student_id"
    t.uuid "program_id"
    t.uuid "course_id"
    t.uuid "batch_id"
    t.string "student_full_name"
    t.string "enrollment_status", default: "pending"
    t.string "course_title"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["batch_id"], name: "index_course_registrations_on_batch_id"
    t.index ["course_id"], name: "index_course_registrations_on_course_id"
    t.index ["program_id"], name: "index_course_registrations_on_program_id"
    t.index ["student_id"], name: "index_course_registrations_on_student_id"
  end

  create_table "courses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "program_id"
    t.string "course_title", null: false
    t.string "course_code", null: false
    t.text "course_description"
    t.integer "course_order"
    t.datetime "course_starting_date", precision: nil
    t.datetime "course_ending_date", precision: nil
    t.decimal "course_price", default: "0.0"
    t.string "created_by"
    t.string "last_updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["program_id"], name: "index_courses_on_program_id"
  end

  create_table "invoice_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "itemable_type"
    t.uuid "itemable_id"
    t.uuid "course_registration_id"
    t.string "item_title"
    t.decimal "price", default: "0.0"
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["course_registration_id"], name: "index_invoice_items_on_course_registration_id"
    t.index ["itemable_type", "itemable_id"], name: "index_invoice_items_on_itemable_type_and_itemable_id"
  end

  create_table "invoices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "student_id"
    t.uuid "batch_id"
    t.uuid "program_id"
    t.string "student_full_name"
    t.string "student_id_number"
    t.string "invoice_number", null: false
    t.decimal "total_price"
    t.decimal "registration_fee", default: "0.0"
    t.decimal "late_registration_fee", default: "0.0"
    t.string "invoice_status", default: "unpaid"
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "due_date", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["batch_id"], name: "index_invoices_on_batch_id"
    t.index ["program_id"], name: "index_invoices_on_program_id"
    t.index ["student_id"], name: "index_invoices_on_student_id"
  end

  create_table "notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "notifiable_type"
    t.uuid "notifiable_id"
    t.uuid "student_id"
    t.string "notification_status", null: false
    t.string "notification_message", null: false
    t.string "notification_card_color", null: false
    t.string "notification_action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["student_id"], name: "index_notifications_on_student_id"
  end

  create_table "payment_methods", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "bank_name", null: false
    t.string "account_full_name", null: false
    t.string "account_number"
    t.string "phone_number"
    t.string "account_type"
    t.string "payment_method_type", null: false
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "payment_transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "invoiceable_type"
    t.uuid "invoiceable_id"
    t.uuid "payment_method_id"
    t.string "account_holder_fullname", null: false
    t.string "phone_number"
    t.string "account_number"
    t.string "transaction_reference"
    t.string "finance_approval_status", default: "pending"
    t.string "last_updated_by"
    t.string "created_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["payment_method_id"], name: "index_payment_transactions_on_payment_method_id"
  end

  create_table "prerequisites", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "course_id"
    t.uuid "prerequisite_id"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["course_id"], name: "index_prerequisites_on_course_id"
    t.index ["prerequisite_id"], name: "index_prerequisites_on_prerequisite_id"
  end

  create_table "programs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "program_name", null: false
    t.string "program_code", null: false
    t.text "overview"
    t.text "program_description"
    t.decimal "total_tuition", default: "0.0"
    t.string "created_by"
    t.string "last_updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "student_courses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "student_id"
    t.uuid "course_id"
    t.string "course_title", null: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["course_id"], name: "index_student_courses_on_course_id"
    t.index ["student_id"], name: "index_student_courses_on_student_id"
  end

  create_table "student_grades", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "course_registration_id"
    t.uuid "student_id"
    t.uuid "course_id"
    t.uuid "program_id"
    t.string "letter_grade"
    t.decimal "assesment_total"
    t.string "updated_by"
    t.string "created_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["course_id"], name: "index_student_grades_on_course_id"
    t.index ["course_registration_id"], name: "index_student_grades_on_course_registration_id"
    t.index ["program_id"], name: "index_student_grades_on_program_id"
    t.index ["student_id"], name: "index_student_grades_on_student_id"
  end

  create_table "students", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "middle_name"
    t.string "gender", null: false
    t.datetime "date_of_birth", precision: nil, null: false
    t.string "place_of_birth"
    t.string "student_id"
    t.string "student_password"
    t.uuid "program_id"
    t.uuid "batch_id"
    t.string "account_status", default: "active"
    t.string "graduation_status"
    t.string "fully_attended", default: "pending"
    t.datetime "fully_attended_date", precision: nil
    t.string "sponsorship_status"
    t.string "moblie_number", null: false
    t.string "alternative_moblie_number"
    t.string "city"
    t.string "country", default: "ET", null: false
    t.string "region"
    t.string "created_by", default: "self"
    t.string "last_updated_by"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["batch_id"], name: "index_students_on_batch_id"
    t.index ["email"], name: "index_students_on_email", unique: true
    t.index ["program_id"], name: "index_students_on_program_id"
    t.index ["reset_password_token"], name: "index_students_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
