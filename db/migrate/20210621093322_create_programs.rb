class CreatePrograms < ActiveRecord::Migration[5.2]
  def change
    create_table :programs, id: :uuid do |t|
      t.string :program_name, null:false
      t.string :program_code, null:false
      t.text :overview
      t.text :program_description
      t.decimal :total_tuition, default: 0.0
      t.string :created_by
      t.string :last_updated_by
      t.timestamps
    end
  end
end
