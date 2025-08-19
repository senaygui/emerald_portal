class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses, id: :uuid do |t|
      t.belongs_to :program, index: true, type: :uuid
      t.string :course_title, null: false
      t.string :course_code, null: false
      t.text :course_description
      t.integer :course_order
      t.datetime :course_starting_date
      t.datetime :course_ending_date
      t.decimal :course_price, default: 0.0

      # #created and updated by
      t.string :created_by
      t.string :last_updated_by

      t.timestamps
    end
  end
end
