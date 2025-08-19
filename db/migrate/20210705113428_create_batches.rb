class CreateBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :batches, id: :uuid do |t|
      t.string :batch_title, null: false
      t.belongs_to :program, index: true, type: :uuid
      t.datetime :starting_date, null: false
      t.datetime :ending_date, null: false

      t.integer :total_number_of_students
      # #created and updated by
      t.string :created_by
      t.string :last_updated_by

      t.timestamps
    end
  end
end
