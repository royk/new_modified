class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :sender_id
      t.integer :recipient_id
      t.boolean :read
      t.integer :conversation_id

      t.timestamps
    end
    add_index :messages, :sender_id
    add_index :messages, :recipient_id
    add_index :messages, :conversation_id
  end
end
