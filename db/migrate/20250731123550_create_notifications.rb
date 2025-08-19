class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications, id: :uuid do |t|
      t.references :notifiable, polymorphic: true, type: :uuid
      t.belongs_to :student, index: true, type: :uuid
      t.string :notification_status, null: false
      t.string :notification_message, null: false
      t.string :notification_card_color, null: false
      t.string :notification_action
      t.timestamps
    end
  end
end
