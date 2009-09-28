class CreateMessageRecipients < ActiveRecord::Migration
  def self.up
    create_table :message_recipients do |t|
      t.references :message, :null => false
      t.references :user
      t.string :parent_id, :null => false
      t.integer :position
      t.boolean :read, :null => false, :default => false
      t.datetime :hidden_at

      t.timestamps
    end
    add_index :message_recipients, [:message_id, :position], :unique => true
  end

  def self.down
    drop_table :message_recipients
  end
end
