class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.integer :sender_id, index: true
      t.integer :recipient_id, index: true
      t.boolean :deleted_by_sender, index: true, default: false
      t.boolean :deleted_by_recipient, index: true, default: false
      t.datetime :read_at
      t.integer :reply_to, index: true

      t.timestamps
    end
  end
end
