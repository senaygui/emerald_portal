# frozen_string_literal: true

class DeviseCreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students, id: :uuid do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## student basic information
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :middle_name
      t.string :gender, null: false
      t.datetime :date_of_birth, null: false
      t.string :place_of_birth

      ## student unique credentials
      t.string :student_id, unique: true
      t.string :student_password

      ## stident admission information
      t.belongs_to :program, index: true, type: :uuid
      t.belongs_to :batch, index: true, type: :uuid

      ## account status
      t.string :account_status, default: 'active'
      t.string :graduation_status
      t.string :fully_attended, default: 'pending'
      t.datetime :fully_attended_date
      t.string :sponsorship_status

      ## address
      t.string :moblie_number, null: false
      t.string :alternative_moblie_number
      t.string :city
      t.string :country, null: false, default: 'ET'
      t.string :region
      # #created and updated by
      t.string :created_by, default: 'self'
      t.string :last_updated_by
      t.timestamps null: false
    end

    add_index :students, :email,                unique: true
    add_index :students, :reset_password_token, unique: true
    # add_index :students, :confirmation_token,   unique: true
    # add_index :students, :unlock_token,         unique: true
  end
end
