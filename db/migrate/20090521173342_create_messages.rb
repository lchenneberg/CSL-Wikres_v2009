class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.references :user
      t.string :subject
      t.text :body
      t.string :status, :null => false, :default => "unsent"
      t.datetime :sent_at
      t.datetime :hidden_at
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
